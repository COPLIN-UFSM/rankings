import csv
import os
import re
import string
import unicodedata
from io import StringIO

import numpy as np
import pandas as pd
from db2 import DB2Connection
from django.conf import settings
from django.core.exceptions import ValidationError
from django.core.files.uploadedfile import InMemoryUploadedFile
from django.shortcuts import render
from tqdm import tqdm

import itertools as it

from sentence_transformers import SentenceTransformer, util

from .universities import __get_all_universities__
from ..models import Ranking, Pilar, ApelidoDeUniversidade, ApelidoDePais, Formulario, Universidade, PilarValor, \
    Metrica, MetricaValor, Pais, TipoApelido


def get_dataframe(file: InMemoryUploadedFile):
    """
    Transforma um arquivo CSV em um DataFrame do Pandas.
    """
    some_file = file.read().decode('utf-8')
    df = pd.read_csv(StringIO(some_file), encoding='utf-8')
    return df


def get_canonical_name(name: str) -> str:
    """
    Retorna o nome canônico (sem pontuação, apóstrofes, siglas, parênteses, etc) de uma palavra.

    :param name: A palavra.
    :return: O seu nome canônico.
    """
    name = name.lower()

    # remove pontuação
    to_replace = list(string.punctuation)
    for rep in to_replace:
        name = name.replace(rep, ' ')

    divided = name.split(' ')
    transf = []
    for p in divided:
        p = p.strip()
        if len(p) > 0:
            transf += [unicodedata.normalize('NFKD', p).encode('ascii', 'ignore').decode()]

    return ' '.join(transf)


def get_metrics(df: pd.DataFrame) -> list:
    """
    Retornas as métricas que estão presentes neste documento.

    :param df: Uma planilha com informações de ranking
    :return: Uma lista de dicionários, um item para cada métrica que está presente no documento.
    """
    qs = Metrica.objects.all()

    metrics = \
        [{'Métrica': m.nome_portugues, 'id_metrica': m.id_metrica} for m in qs] + \
        [{'Métrica': m.nome_ingles, 'id_metrica': m.id_metrica} for m in qs]

    present = []
    for metric in metrics:
        if metric['Métrica'] in df.columns:
            present += [metric]

    return present


def get_pillars(df, id_ranking) -> list:
    en = set(pd.DataFrame(Pilar.objects.filter(ranking__id_ranking=id_ranking).values('id_pilar', 'nome_ingles')).to_dict(orient='list')['nome_ingles'])
    pt = set(pd.DataFrame(Pilar.objects.filter(ranking__id_ranking=id_ranking).values('id_pilar', 'nome_portugues')).to_dict(orient='list')['nome_portugues'])

    columns = set(df.columns)

    if len(en.intersection(columns)) == len(en):
        elected = pd.DataFrame(Pilar.objects.filter(ranking__id_ranking=id_ranking).values('id_pilar', 'nome_ingles'))
    elif len(pt.intersection(columns)) == len(pt):
        elected = pd.DataFrame(Pilar.objects.filter(ranking__id_ranking=id_ranking).values('id_pilar', 'nome_portugues'))
    else:

        if len(en.intersection(columns)) > len(pt.intersection(columns)):
            missing = en - columns
        else:
            missing = pt - columns

        missing_html = ''.join([f'<li>{x}</li>' for x in missing])

        raise ValidationError(
            f'<p>Erro: Os pilares informados na planilha devem ser exatamente os que são informados no banco de dados! '
            f'Se novos pilares foram adicionados ao Ranking, você terá que adicioná-los manualmente na tela de '
            f'administrador deste site. Se os nomes dos pilares forem semelhantes, mas não exatamente iguais, você pode'
            f' simplesmente trocar o nome do pilar na planilha para o nome do banco de dados. Os nomes dos pilares '
            f'devem ser consistentes: ou todos escritos em inglês, ou todos escritos em português. Verifique a grafia '
            f'correta na tela de administrador.</p>'
            f'<p>Pilares que faltam na planilha:</p><ul>{missing_html}</ul>'
        )

    elected.columns = ['id_pilar', 'Pilar']
    return elected.to_dict(orient='records')


def check_ranking_file_consistency(df: pd.DataFrame, id_ranking: int) -> pd.DataFrame:
    """
    Verifica se a planilha de um ranking que está sendo inserido possui todos os pilares do ranking.
    Se houver alguma inconsistência, levanta uma exceção do tipo ValidationError com a mensagem do erro.

    :param df: DataFrame que está sendo inserido no site
    :param id_ranking: ID do ranking na tabela Rankings
    """
    # verifica colunas básicas
    if 'Universidade' not in df.columns:
        raise ValidationError(f'A planilha deve conter uma coluna de nome \'Universidade\'!')
    if 'País' not in df.columns:
        raise ValidationError(f'A planilha deve conter uma coluna de nome \'País\'!')
    if 'Ano' not in df.columns:
        raise ValidationError(f'A planilha deve conter uma coluna de nome \'Ano\'!')

    def __convert_column_values_to_list__(_x) -> list:
        if pd.isna(_x):
            return [None, None]
        if isinstance(_x, float) or isinstance(_x, int):
            return [float(_x), None]

        _x = re.findall('([0-9\.]+)', _x)

        # for rep in string.punctuation + '—–':
        #     _x = _x.replace(rep, ' ')
        # _x = _x.split()
        return ([float(y) for y in _x] + [None, None])[:2]

    # verifica se o ranking existe no banco de dados
    ranking_obj = Ranking.objects.filter(id_ranking=id_ranking).first()
    if ranking_obj is None:
        raise ValidationError(f'O ranking informado não foi encontrado na base de dados! Se este for um novo '
                              f'ranking, você terá que adicioná-lo manualmente na tela de administrador.')

    # verifica se todos os pilares estão no documento
    pillars = get_pillars(df, id_ranking=id_ranking)
    metrics = get_metrics(df)

    # reporter é colocado pelo THE ranking para universidades que estão relacionadas mas não possuem uma ordem
    df = df.replace({None: np.nan, '-': np.nan, 'Reporter': np.nan, 'reporter': np.nan,
                     'n/a': np.nan, 'NA': np.nan, 'na': np.nan})

    column_renaming = {}
    for pillar in pillars:
        try:
            new_name = pillar['Pilar'] + '_as_list'
            column_renaming[new_name] = pillar['Pilar']

            df.loc[:, new_name] = df[pillar['Pilar']].apply(__convert_column_values_to_list__)
        except Exception as e:
            raise ValidationError(
                'Para cada coluna de pilar, os números devem ter a casa decimal como ponto (e.g. 10.9), e serem '
                'separados por travessão (-), caso possuam mais de um valor.'
            )

    df = df.drop(columns=column_renaming.values())
    df = df.rename(columns=column_renaming)

    column_renaming = {}
    for metric in metrics:
        try:
            new_name = metric['Métrica'] + '_as_list'
            column_renaming[new_name] = metric['Métrica']

            df.loc[:, new_name] = df[metric['Métrica']].apply(__convert_column_values_to_list__)
        except Exception as e:
            raise ValidationError(
                'Para cada coluna de métrica, os números devem ter a casa decimal como ponto (e.g. 10.9), e serem '
                'separados por travessão (-), caso possuam mais de um valor.'
            )

    df = df.drop(columns=column_renaming.values())
    df = df.rename(columns=column_renaming)

    return df


def insert_id_pais(df: pd.DataFrame) -> pd.DataFrame:
    """
    Dado um dataframe que é a coleta de um ranking feita pela internet, insere o id_pais e o id_apelido_pais para cada
    linha.
    """
    def __prepare__(_df, set_pais=True, set_apelido=True):
        if set_pais:
            _df['id_pais'] = np.nan
        if set_apelido:
            _df['id_apelido_pais'] = np.nan

        _df['id_pais'] = _df['id_pais'].astype('Int64')
        _df['id_apelido_pais'] = _df['id_apelido_pais'].astype('Int64')

        _df['País (canonical)'] = _df['País'].apply(lambda x: hash(get_canonical_name(str(x)))).astype('Int64')
        return _df

    if 'País' not in df.columns:
        raise ValidationError('A coluna \'País\' precisa estar no DataFrame!')

    original_columns = df.columns.tolist()

    df = __prepare__(df, set_pais=True, set_apelido=True)

    db = pd.DataFrame(ApelidoDePais.objects.all().values('pais_id', 'id_apelido', 'apelido'))
    db.columns = ['id_pais', 'id_apelido_pais', 'País']
    db = __prepare__(db, set_pais=False, set_apelido=False)

    joined = pd.merge(df, db, on='País (canonical)', how='left', suffixes=('', '_db'))

    joined.loc[:, 'id_pais'] = joined.loc[:, 'id_pais_db']
    joined.loc[:, 'id_apelido_pais'] = joined.loc[:, 'id_apelido_pais_db']

    joined = joined[original_columns + ['id_pais', 'id_apelido_pais']]
    joined = joined.drop_duplicates(subset=['Ano', 'Universidade', 'id_pais'], keep='first')
    return joined


def __remove_forms__(id_formulario=None) -> None:
    """
    Remove formulários do banco de dados e da pasta local do computador.

    :param id_formulario: Opcional - um formulário em específico para ser removido. Se não for fornecido, removerá
        todos os formulários.
    """
    if id_formulario is not None:
        qs = Formulario.objects.filter(id_formulario=id_formulario)
        for q in qs:
            os.remove(q.formulario.name)
            q.delete()

    else:  # remove todos os formulários
        Formulario.objects.all().delete()

        from django.conf import settings
        _files = [x for x in os.listdir(os.path.join(settings.BASE_DIR, 'uploads')) if x != '.gitignore']
        for _file in _files:
            os.remove(os.path.join(settings.BASE_DIR, 'uploads', _file))


def __append_row__(i, row, pillars, metrics, to_add_pillars, to_add_metrics):
    for pillar in pillars:
        nome_pilar = pillar['Pilar']
        id_pilar = pillar['id_pilar']

        try:
            p_values = eval(row[nome_pilar])  # converte para uma lista
        except TypeError:
            p_values = row[nome_pilar]  # já é uma lista

        pilar_valor = PilarValor(
            apelido_universidade_id=int(row['id_apelido_universidade']),
            pilar_id=int(id_pilar),
            ano=int(row['Ano']),
            valor_inicial=p_values[0],
            valor_final=p_values[1],
        )
        to_add_pillars += [pilar_valor]

    for metric in metrics:
        nome_metrica = metric['Métrica']
        id_metrica = metric['id_metrica']

        try:
            m_values = eval(row[nome_metrica])  # converte para uma lista
        except TypeError:
            m_values = row[nome_metrica]  # já é uma lista

        metrica_valor = MetricaValor(
            apelido_universidade_id=int(row['id_apelido_universidade']),
            metrica_id=int(id_metrica),
            ano=int(row['Ano']),
            valor_inicial=m_values[0],
            valor_final=m_values[1]
        )
        to_add_metrics += [metrica_valor]

    return to_add_pillars, to_add_metrics


def insert_ranking_data(df, id_ranking, id_formulario, batch_size=999):
    """
    Insere os dados do formulário nas tabelas pertinentes.

    :param df: um formulário, com id_universidade e id_pais definido para todas as linhas.
    :param id_ranking: o ID do ranking que será inserido.
    :param id_formulario: ID do formulário atrelado a esta inserção.
    :param batch_size: opcional - o número de tuplas a serem inseridas com um comando INSERT no banco de dados. O padrão
        é 999.
    """
    # verifica colunas básicas
    if 'id_apelido_universidade' not in df.columns:
        raise ValidationError(f'A planilha deve conter uma coluna de nome \'id_apelido_universidade\'!')
    if 'Ano' not in df.columns:
        raise ValidationError(f'A planilha deve conter uma coluna de nome \'Ano\'!')

    pillars = get_pillars(df, id_ranking=id_ranking)
    metrics = get_metrics(df)

    ano = df['Ano'].iloc[0]
    db_pillar_values = pd.DataFrame(
        PilarValor.objects.filter(pilar__ranking__id_ranking=id_ranking, ano=ano).values_list(
        'apelido_universidade_id', 'pilar_id', 'ano'
        ),
        columns=['id_apelido_universidade', 'id_pilar', 'ano']
    )

    to_add_pillars = []
    to_add_metrics = []
    for i, row in df.iterrows():
        to_add_pillars, to_add_metrics = __append_row__(i, row, pillars, metrics, to_add_pillars, to_add_metrics)

    df_pillar_values = pd.DataFrame(
        [(x.apelido_universidade_id, x.pilar_id, x.ano) for x in to_add_pillars],
        columns=['id_apelido_universidade', 'id_pilar', 'ano']
    )

    # TODO inserir métricas tb!
    merged = pd.merge(
        df_pillar_values,
        db_pillar_values,
        on=['id_apelido_universidade', 'id_pilar', 'ano'],
        how='left',
        indicator=True
    )

    filtered_pillars = list(it.compress(
        to_add_pillars,
        (merged['_merge'] == 'left_only').values.tolist()
    ))

    # já tentei inserir com o coplin-db2, mas demora tanto tempo quanto... o gargalo é no banco de dados!
    for pv in tqdm(filtered_pillars, desc='Inserindo valores dos pilares no banco de dados'):
        pv.save()

    # mas deixo aqui o código caso no futuro uma solução diferente seja implementada
    # with DB2Connection(settings.DATABASE_CREDENTIALS_PATH) as conn:
    #     for pv in tqdm(filtered_pillars, desc='Inserindo valores dos pilares no banco de dados'):
            # conn.insert(
            #     table_name='R_PILARES_VALORES',
            #     row={
            #         'ID_APELIDO_UNIVERSIDADE': pv.apelido_universidade_id,
            #         'ID_PILAR': pv.pilar_id,
            #         'ANO': pv.ano,
            #         'VALOR_INICIAL': pv.valor_inicial,
            #         'VALOR_FINAL': pv.valor_final
            #     }
            # )

    # PilarValor.objects.bulk_create(filtered_pillars)
    # MetricaValor.objects.bulk_create(to_add_metrics)

    __remove_forms__(id_formulario=id_formulario)


def insert_id_university(df: pd.DataFrame) -> pd.DataFrame:
    if 'Universidade' not in df.columns:
        raise ValidationError('A coluna \'Universidade\' precisa estar no DataFrame!')
    if 'id_pais' not in df.columns:
        raise ValidationError('A coluna \'id_pais\' precisa estar no DataFrame!')
    if 'id_apelido_pais' not in df.columns:
        raise ValidationError('A coluna \'id_apelido_pais\' precisa estar no DataFrame!')

    # bd_unis possui as universidades do banco de dados
    db = __get_all_universities__()
    df['Universidade_encoded'] = df['Universidade'].apply(lambda x: x.upper().strip().encode('unicode_escape').decode('latin-1').upper())
    db['Universidade_encoded'] = db['Universidade'].apply(lambda x: x.upper().strip().encode('latin-1').decode('latin-1').upper())

    # insere id_universidade para linhas que o nome da universidade foi encontrado no banco
    df['id_universidade'] = np.nan
    df['id_apelido_universidade'] = np.nan
    df.loc[:, 'id_universidade'] = df['id_universidade'].astype(float)
    df.loc[:, 'id_pais'] = df['id_pais'].astype(float)
    df.loc[:, 'id_apelido_universidade'] = df['id_apelido_universidade'].astype(float)

    db.loc[:, 'id_universidade'] = db['id_universidade'].astype(float)
    db.loc[:, 'id_pais'] = db['id_pais'].astype(float)
    db.loc[:, 'id_apelido_universidade'] = db['id_apelido_universidade'].astype(float)

    joined = pd.merge(df, db, on=['Universidade_encoded', 'id_pais'], how='left', suffixes=('', '_db'))

    joined.loc[joined.index, 'id_universidade'] = joined.loc[joined.index, 'id_universidade_db']
    joined.loc[joined.index, 'id_apelido_universidade'] = joined.loc[joined.index, 'id_apelido_universidade_db']

    df = joined[df.columns]

    # se alguma universidade do arquivo do ranking anda não tem o id_universidade setado
    if pd.isna(df['id_apelido_universidade']).sum() > 0:
        missing = df.loc[
            pd.isna(df['id_apelido_universidade'])
        ].drop_duplicates(
            subset=['Universidade_encoded', 'id_pais']
        )

        from sentence_transformers import SentenceTransformer, util
        model = SentenceTransformer('all-MiniLM-L6-v2')

        for i, row in tqdm(missing.iterrows(), total=len(missing), desc='Inserindo universidades no banco'):
            try:
                uni_name = row['Universidade'].upper().strip().encode('unicode_escape').decode('latin-1').upper()
                id_pais = row['id_pais']

                candidates = db.loc[db['id_pais'] == id_pais]

                idx = get_closest_match(uni_name, candidates['Universidade_encoded'].tolist(), model=model)
                id_universidade = candidates.iloc[idx]['id_universidade']

                df.loc[i, 'id_universidade'] = id_universidade

                apelido = ApelidoDeUniversidade(
                    universidade=Universidade.objects.get(id_universidade=id_universidade),
                    apelido=uni_name
                )
                apelido.save()
                df.loc[i, 'id_apelido_universidade'] = apelido.id_apelido

            except IndexError:  # nenhuma correspondência encontrada
                universidade = Universidade(
                    nome_portugues=uni_name,
                    nome_ingles=uni_name,
                    pais_apelido_id=int(row['id_apelido_pais'])
                )
                universidade.save()

                apelido = ApelidoDeUniversidade(
                    universidade=universidade,
                    apelido=uni_name
                )
                apelido.save()

                index = (df['Universidade_encoded'] == uni_name) & (df['id_pais'] == id_pais)
                df.loc[index, 'id_universidade'] = universidade.id_universidade
                df.loc[index, 'id_apelido_universidade'] = apelido.id_apelido

    return df


def load_ranking_file(id_formulario: int) -> pd.DataFrame:
    f = Formulario.objects.filter(id_formulario=id_formulario).first()
    if f is None:
        raise ValidationError(
            'Um id_formulario foi fornecido, mas não existe um formulário correspondente salvo no banco de dados!'
        )
    df = pd.read_csv(
        f.formulario.name, index_col=0, encoding='utf-8', sep=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC
    )
    df.index = df.index.astype(int)
    columns = ['Ano', 'id_pais', 'id_apelido_pais', 'id_universidade', 'id_apelido_universidade']
    for column in columns:
        if column in df.columns:
            df[column] = df[column].astype('Int64')

    return df


def save_ranking_file(df: pd.DataFrame, id_ranking: int, id_formulario: int = None) -> tuple:
    # se existe um id_formulario definido, quer dizer que este formulário está sendo atualizado
    if id_formulario is not None:
        f = Formulario.objects.get(id_formulario=id_formulario)
        if f is None:
            raise ValidationError(
                'Um id_formulario foi fornecido, mas não existe um formulário correspondente salvo no banco de dados!'
            )
        elif int(f.ranking.id_ranking) != int(id_ranking):
            raise ValidationError(
                'O id_ranking fornecido para a função não é o mesmo definido no banco de dados!'
            )
        else:
            upload_path = f.formulario.name
    else:  # caso contrário, será a primeira vez que será salvo
        if len(Formulario.objects.all()) > 0:
            id_formulario = Formulario.objects.latest('id_formulario').id_formulario + 1
        else:
            id_formulario = 1

        upload_path = os.path.join(
            settings.BASE_DIR, Formulario.formulario.field.upload_to, f'formulario_{id_formulario}.csv'
        )

        formulario = Formulario(id_formulario=id_formulario, ranking_id=id_ranking, formulario=upload_path)
        formulario.save()

    columns = ['Ano', 'id_pais', 'id_apelido_pais', 'id_universidade', 'id_apelido_universidade']
    for column in columns:
        if column in df.columns:
            df[column] = df[column].astype('Int64')

    df.to_csv(upload_path, index=True, sep=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC, encoding='utf-8')

    return df, id_formulario


def get_closest_match(name: str, candidates: list, threshold: float = 0.8, model: SentenceTransformer = None) -> int:
    """
    Encontra a melhor correspondência para um nome em uma lista de candidatos com base na similaridade de strings.

    :param name: O nome de referência.
    :param candidates: Lista de nomes candidatos.
    :param threshold: Limite de similaridade para considerar uma correspondência válida.
    :return: O nome mais próximo encontrado na lista de candidatos.
    """
    if model is None:
        model = SentenceTransformer('all-MiniLM-L6-v2')

    # Get embeddings
    ref_emb = model.encode(name, convert_to_tensor=True)
    candidate_embeddings = model.encode(candidates, convert_to_tensor=True)

    # Compute cosine similarity
    similarities = util.cos_sim(ref_emb, candidate_embeddings)[0].cpu().numpy()
    argmax = similarities.argmax()
    if similarities[argmax] > threshold:
        return argmax

    raise IndexError(f'Nenhum item da lista de candidatos possui similaridade acima do threshold de {threshold}!')


def __missing_countries_preview__(request, df, id_formulario, id_ranking):
    df = insert_id_pais(df)
    df, id_formulario = save_ranking_file(df, id_ranking=id_ranking, id_formulario=id_formulario)

    # se algum registro não tem id de país setado
    if df['id_pais'].isna().sum() > 0:
        df.reset_index(inplace=True)
        # o índice não quer dizer muita coisa nesse contexto, mas é necessário um número
        rows = df.loc[df['id_pais'].isna(), ['index', 'id_pais', 'País']].drop_duplicates(subset=['País'])
        return render(
            request,
            'rankings/countries/missing/preview.html',
            context={
                'id_formulario': id_formulario,
                'id_ranking': id_ranking,
                'rows': rows.to_dict(orient='records'),
                'country_options': [{'id_pais': '', 'nome_portugues': ''}] + [
                    {'id_pais': x.id_pais, 'nome_portugues': x.nome_portugues}
                    for x in Pais.objects.all()
                ],
                'country_type_options': [{'id_tipo_apelido': '', 'tipo_apelido': ''}] + pd.DataFrame(
                    TipoApelido.objects.values('id_tipo_apelido', 'tipo_apelido')
                ).to_dict(orient='records')
            }
        )

    return request, df, id_ranking, id_formulario
