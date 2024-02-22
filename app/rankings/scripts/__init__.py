import csv
import os
import re
import string
import unicodedata
from io import StringIO

import django
import numpy as np
import pandas as pd
from django.conf import settings
from django.core.exceptions import ValidationError
from django.core.files.uploadedfile import InMemoryUploadedFile
from tqdm import tqdm

from .universities import __get_all_universities__
from ..models import Ranking, Pilar, ApelidoDeUniversidade, ApelidoDePais, Formulario, Universidade, PilarValor, \
    Metrica, MetricaValor


def get_dataframe(file: InMemoryUploadedFile):
    some_file = file.read().decode('utf-8')
    df = pd.read_csv(StringIO(some_file))
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
            f'simplesmente trocar o nome do pilar na planilha para o nome do banco de dados. Os nomes dos pilares '
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

    for pillar in pillars:
        try:
            df.loc[:, pillar['Pilar']] = df[pillar['Pilar']].apply(__convert_column_values_to_list__)
        except Exception as e:
            raise ValidationError(
                'Para cada coluna de pilar, os números devem ter a casa decimal como ponto (e.g. 10.9), e serem '
                'separados por travessão (-), caso possuam mais de um valor.'
            )
    for metric in metrics:
        try:
            df.loc[:, metric['Métrica']] = df[metric['Métrica']].apply(__convert_column_values_to_list__)
        except Exception as e:
            raise ValidationError(
                'Para cada coluna de métrica, os números devem ter a casa decimal como ponto (e.g. 10.9), e serem '
                'separados por travessão (-), caso possuam mais de um valor.'
            )

    return df


def insert_id_country(df: pd.DataFrame) -> pd.DataFrame:
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

    df = __prepare__(df)

    db = pd.DataFrame(ApelidoDePais.objects.all().values('pais_id', 'id_apelido', 'apelido'))
    db.columns = ['id_pais', 'id_apelido_pais', 'País']
    db = __prepare__(db, set_pais=False, set_apelido=False)

    joined = df.merge(db, on='País (canonical)', how='left', suffixes=('', '_db'))

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


def __insert_bulk_data__(to_add_pillars, to_add_metrics):
    def __insert_rows__(rows, model):
        try:
            model.objects.bulk_create(rows)  # tenta inserir em conjunto
        except django.db.utils.IntegrityError:  # alguma tupla está duplicada; insere uma a uma
            pass  # ignora
            # for row in rows:
            #     try:
            #         row.save()
            #     except django.db.utils.IntegrityError:  # se continuar dando erro, ignora e segue em frente
            #         pass

    __insert_rows__(to_add_pillars, PilarValor)
    __insert_rows__(to_add_metrics, MetricaValor)

    to_add_pillars = []
    to_add_metrics = []

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

    with tqdm(range(len(df)), desc='inserindo valores dos pilares e métricas...') as pbar:
        to_add_pillars = []
        to_add_metrics = []
        for i, row in df.iterrows():
            to_add_pillars, to_add_pillars, __append_row__(i, row, pillars, metrics, to_add_pillars, to_add_metrics)
            if len(to_add_pillars) >= batch_size or len(to_add_metrics) >= batch_size:
                to_add_pillars, to_add_metrics = __insert_bulk_data__(to_add_pillars, to_add_metrics)

            pbar.update(1)

    to_add_pillars, to_add_metrics = __insert_bulk_data__(to_add_pillars, to_add_metrics)

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

    # insere id_universidade para linhas que o nome da universidade foi encontrado no banco
    df['id_universidade'] = np.nan
    df['id_apelido_universidade'] = np.nan
    df['id_universidade'] = df['id_universidade'].astype('Int64')
    df['id_apelido_universidade'] = df['id_apelido_universidade'].astype('Int64')

    df_columns = df.columns.tolist()

    joined = df.merge(db, on=['Universidade', 'id_pais'], how='left', suffixes=('', '_db'))

    joined.loc[:, 'id_universidade'] = joined['id_universidade_db']
    joined.loc[:, 'id_apelido_universidade'] = joined['id_apelido_universidade_db']

    df = joined[df_columns]
    # TODO esta função está removendo mais linhas do que deveria!
    # df = df.drop_duplicates(subset=['Ano', 'id_pais', 'id_apelido_universidade'], keep='first')

    # se alguma universidade do arquivo do ranking anda não tem o id_universidade setado
    if df['id_apelido_universidade'].isna().sum() > 0:
        missing = df.loc[df['id_apelido_universidade'].isna()].drop_duplicates(subset=['Universidade', 'id_pais'])

        with tqdm(range(len(missing)), desc='Inserindo universidades no banco') as pbar:
            for i, row in missing.iterrows():
                universidade = Universidade(
                    nome_portugues=row['Universidade'],
                    nome_ingles=row['Universidade'],
                    pais_apelido_id=int(row['id_apelido_pais'])
                )
                universidade.save()
                apelido = ApelidoDeUniversidade(
                    universidade=universidade,
                    apelido=row['Universidade']
                )
                apelido.save()

                uni_name = row['Universidade']
                id_pais = row['id_pais']

                index = (df['Universidade'] == uni_name) & (df['id_pais'] == id_pais)
                df.loc[index, 'id_universidade'] = universidade.id_universidade
                df.loc[index, 'id_apelido_universidade'] = apelido.id_apelido

                pbar.update(1)

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

