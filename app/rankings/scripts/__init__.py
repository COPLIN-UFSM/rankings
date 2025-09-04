import csv
import os
import string

import pandas as pd
import unicodedata
from django.conf import settings
from django.core.exceptions import ValidationError
from django.utils import timezone
from sentence_transformers import SentenceTransformer, util

from ..models import ApelidoDeUniversidade, Ranking, IES, Pilar, UltimaCarga


def update_ultima_carga(nome_tabela, nome_ajustado):
    try:
        uc_pv = UltimaCarga.objects.get(nome_tabela=nome_tabela)
        uc_pv.dh_ultima_carga = timezone.now()
        uc_pv.save()
    except UltimaCarga.DoesNotExist:
        last_id = UltimaCarga.objects.all().order_by('id_ultima_carga').last().id_ultima_carga

        uc_pv = UltimaCarga(
            id_ultima_carga=last_id + 1,
            nome_tabela=nome_tabela,
            nome_ajustado=nome_ajustado
        )
        uc_pv.save()


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


def get_document_pillars(df: pd.DataFrame, ranking: Ranking) -> list:
    """
    Dado um ID_RANKING e um formulário no formato pd.DataFrame, preenche o ID_PILAR para cada linha do DataFrame.
    """
    pillars = Pilar.objects.filter(ranking=ranking)

    en = set(pd.DataFrame(pillars.values('id_pilar', 'nome_ingles')).to_dict(orient='list')['nome_ingles'])
    pt = set(pd.DataFrame(pillars.values('id_pilar', 'nome_portugues')).to_dict(orient='list')['nome_portugues'])

    columns = set(df.columns)

    if len(en.intersection(columns)) == len(en):
        elected = pd.DataFrame(pillars.values('id_pilar', 'nome_ingles'))
    elif len(pt.intersection(columns)) == len(pt):
        elected = pd.DataFrame(pillars.values('id_pilar', 'nome_portugues'))
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


def save_ranking_file(df: pd.DataFrame, ranking: Ranking, id_formulario: int = None) -> tuple:
    # se existe um id_formulario definido, quer dizer que este formulário está sendo atualizado
    if id_formulario is not None:
        f = Formulario.objects.get(id_formulario=id_formulario)
        if f is None:
            raise ValidationError(
                'Um id_formulario foi fornecido, mas não existe um formulário correspondente salvo no banco de dados!'
            )
        elif int(f.ranking.id_ranking) != ranking.id_ranking:
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

        formulario = Formulario(id_formulario=id_formulario, ranking=ranking, formulario=upload_path)
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

    if len(candidates) == 0:
        raise IndexError(f'A lista de candidatos está vazia!')

    # Get embeddings
    ref_emb = model.encode(name, convert_to_tensor=True)
    candidate_embeddings = model.encode(candidates, convert_to_tensor=True)

    # Compute cosine similarity
    similarities = util.cos_sim(ref_emb, candidate_embeddings)[0].cpu().numpy()
    argmax = similarities.argmax()
    if similarities[argmax] > threshold:
        return argmax

    raise IndexError(f'Nenhum item da lista de candidatos possui similaridade acima do threshold de {threshold}!')

def get_all_ies() -> pd.DataFrame:
    """
    Coleta todas as IES do banco de dados e retorna em um pandas.DataFrame.
    """

    df = pd.DataFrame(IES.objects.all().values('cod_ies', 'nome_ies'))
    if len(df) == 0:
        df = pd.DataFrame(columns=['cod_ies', 'nome_ies'])
    return df


def get_all_db_universities() -> pd.DataFrame:
    """
    Coleta todas as universidades do banco de dados e retorna em um pandas.DataFrame.
    """
    mapping = {
        'universidade__id_universidade': 'id_universidade',
        'id_apelido': 'id_apelido_universidade',
        'apelido': 'Universidade',
        'universidade__pais_apelido__id_apelido': 'id_apelido_pais',
        'universidade__pais_apelido__pais__id_pais': 'id_pais',
        'universidade__pais_apelido__pais__nome_ingles': 'País'
    }

    df = pd.DataFrame(ApelidoDeUniversidade.objects.all().values(*mapping.keys()))
    if len(df) == 0:
        df = pd.DataFrame(columns=mapping.values())
    else:
        df = df.rename(columns=mapping)

    return df
