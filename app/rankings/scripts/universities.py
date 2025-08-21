import django
import pandas as pd
from tqdm import tqdm

from ..models import Universidade, ApelidoDeUniversidade, PilarValor, GrupoDeUniversidades, UniversidadesParaGrupos


def __get_all_universities__():
    df = pd.DataFrame(ApelidoDeUniversidade.objects.all().values(
        'universidade__id_universidade',
        'id_apelido',
        'apelido',
        'universidade__pais_apelido__id_apelido',
        'universidade__pais_apelido__pais__id_pais',
        'universidade__pais_apelido__pais__nome_ingles'
    ))
    df.columns = ['id_universidade', 'id_apelido_universidade', 'Universidade', 'id_apelido_pais', 'id_pais', 'País']

    return df


def __get_unused_universities_nicknames__() -> django.db.models.QuerySet:
    """
    Retorna um QuerySet com objetos ApelidoDeUniversidade que não são usados em nenhum PilarValor.
    """
    usados = pd.DataFrame(PilarValor.objects.values('apelido_universidade_id').distinct())
    usados = usados.rename(columns={'apelido_universidade_id': 'id_apelido'})
    usados['usado'] = 1
    todos = pd.DataFrame(ApelidoDeUniversidade.objects.values('id_apelido').distinct())

    nao_usados = pd.merge(todos, usados, how='left')
    nao_usados_ids = nao_usados.loc[pd.isna(nao_usados['usado']), 'id_apelido'].values.tolist()
    return ApelidoDeUniversidade.objects.filter(id_apelido__in=nao_usados_ids)


def __get_unused_universities__() -> django.db.models.QuerySet:
    """
    Retorna um QuerySet com objetos Universidade que não são usados em nenhum PilarValor.
    """
    todos = pd.DataFrame(Universidade.objects.values('id_universidade').distinct())
    usados = pd.DataFrame(PilarValor.objects.values('apelido_universidade__universidade__id_universidade').distinct())
    usados = usados.rename(columns={'apelido_universidade__universidade__id_universidade': 'id_universidade'})
    usados['usado'] = 1

    nao_usados = pd.merge(todos, usados, how='left')
    nao_usados_ids = nao_usados.loc[pd.isna(nao_usados['usado']), 'id_universidade'].values.tolist()
    return Universidade.objects.filter(id_universidade__in=nao_usados_ids)


def __get_universities_relationships__(qs):
    objs = UniversidadesParaGrupos.objects.filter(
        universidade__id_universidade__in=qs.values_list('id_universidade', flat=True)
    )
    return objs


def remove_unused_universities_and_nicknames():
    def process(qs):
        with tqdm(range(len(qs)), desc='Removendo universidades não usadas') as pbar:
            for obj in qs:
                obj.delete()
                pbar.update(1)

    nicknames = __get_unused_universities_nicknames__()
    names = __get_unused_universities__()
    relationships = __get_universities_relationships__(names)

    process(relationships)
    process(nicknames)
    process(names)


def merge_replicate_universities(df):
    pass