import os

import pandas as pd
from tqdm import tqdm

from ...models import IES

try:
    from ..rankings.models import Universidade, ApelidoDeUniversidade, ApelidoDePais
except ImportError:
    from rankings.models import Universidade, ApelidoDeUniversidade, ApelidoDePais

def populate_brazilian_universities() -> dict:
    """
    Importa dados das IES brasileiras do banco de dados.

    :return: Um dicionário com a quantidade de linhas inseridas no banco de dados.
    """
    read_path = os.path.join(os.path.dirname(__file__), '..', '..', 'tests', 'data', 'test_ies.csv')
    if not os.path.exists(read_path):
        raise FileNotFoundError(
            'Esse script precisa de um arquivo de csv com as IES brasileiras (da tabela IES do banco bee) em '
            'tests/data/test_ies.csv, que é gerado pelo script tests/generate_test_ies_df.py'
        )

    brasil = ApelidoDePais.objects.get(apelido__iexact='Brasil')
    id_apelido_pais = brasil.pk

    df = pd.read_csv(read_path)
    df = df.loc[df['País'] == 'Brasil']

    gb = df.groupby(by=['COD_IES'], as_index=False)

    count_unis = 0
    count_apelidos = 0

    for cod_ies, index in tqdm(
        gb.groups.items(),
        total=len(gb.groups.items()),
        desc='Inserindo universidades brasileiras no banco de dados'
    ):
        rows = gb.get_group((cod_ies, ))

        universidade = Universidade(
            nome_portugues=rows.iloc[0]['Universidade'],
            nome_ingles=rows.iloc[0]['Universidade'],
            cod_ies=cod_ies,
            pais_apelido_id=id_apelido_pais
        )
        universidade.save()

        count_unis += 1

        apelidos = []
        for i, row in rows.iterrows():
            apelidos += [
                ApelidoDeUniversidade(
                    universidade=universidade,
                    apelido=row['Universidade']
                )
            ]

        ApelidoDeUniversidade.objects.bulk_create(apelidos)
        count_apelidos += len(apelidos)

    return {'universidades': count_unis, 'apelidos': count_apelidos}

def run_several(connection, paths: list) -> None:
    for path in paths:
        read_contents_and_run(connection, path)

def read_contents_and_run(connection, path: str):
    with open(path, 'r', encoding='utf-8') as read_file:
        script_contents = read_file.read()

    with connection.cursor() as cursor:
        print(f'Executando script {os.path.basename(path)}')
        for command in script_contents.split(';'):
            if connection.vendor == 'sqlite':
                command = command.replace(
                    'GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1)',
                    'AUTOINCREMENT'
                )
                if 'COMMENT ON' not in command:
                    cursor.execute(command + ';')

def populate_all_tables(connection) -> None:
    print('Repopulando todas as tabelas')
    if connection.vendor == 'sqlite':
        if not IES.objects.filter(cod_ies=582).exists():
            IES(cod_ies=582, nome_ies='Universidade Federal de Santa Maria', sigla_ies='UFSM').save()
        if not IES.objects.filter(cod_ies=5322).exists():
            IES(cod_ies=5322, nome_ies='Universidade Federal do Pampa', sigla_ies='Unipampa').save()

    _common = os.path.join(os.path.dirname(__file__), '..', 'sql', 'insert')
    for sql_script in sorted(os.listdir(_common)):
        read_contents_and_run(connection, os.path.join(_common, sql_script))

def drop_all_tables(connection):
    print('Removendo todas as tabelas')
    _common = os.path.join(os.path.dirname(__file__), '..', 'sql', 'drop')
    for sql_script in sorted(os.listdir(_common)):
        read_contents_and_run(connection, os.path.join(_common, sql_script))


def create_all_tables(connection):
    print('Recriando todas as tabelas')
    _common = os.path.join(os.path.dirname(__file__), '..', 'sql', 'create')
    for sql_script in sorted(os.listdir(_common)):
        read_contents_and_run(connection, os.path.join(_common, sql_script))


def soft_populate(connection) -> None:
    """
    Reinsere dados em tabelas depois de um soft drop.
    """
    print('Repopulando tabelas')

    if connection.vendor == 'sqlite':
        drop_all_tables(connection)
        create_all_tables(connection)
        populate_all_tables(connection)

    sql_scripts = [
        os.path.join(os.path.join(os.path.dirname(__file__), '..', 'sql'), x) for x in [
            os.path.join('insert', '07_universidades.sql'),
            os.path.join('insert', '08_universidades_apelidos.sql')
        ]
    ]

    run_several(connection, sql_scripts)
    populate_brazilian_universities()