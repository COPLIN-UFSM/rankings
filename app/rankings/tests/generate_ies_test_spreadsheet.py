import csv

import pandas as pd
from db2 import DB2Connection
import os


def main(path):
    with DB2Connection(path) as conn:
        df = conn.query_to_dataframe('''
            select COD_IES, 
                   coalesce(SIGLA_IES, '') as SIGLA_IES, 
                   NOME_IES as "Universidade",
            'Brasil' as "País",
            2025 AS "Ano",
            1 as "Sample Pillar 1 (Score)",
            2 as "Sample Pillar 1 (Rank)",
            3 as "Sample Pillar 2 (Score)",
            4 as "Sample Pillar 2 (Rank)"
            from ies
            order by COD_IES;
        ''')

        uppercase = df.copy(deep=True)
        uppercase['Universidade'] = uppercase['Universidade'].str.upper()

        acronym = df.copy(deep=True)
        acronym['Universidade'] = acronym['Universidade'] + ' ' + acronym['SIGLA_IES']

        lowercase = df.copy(deep=True)
        lowercase['Universidade'] = lowercase['Universidade'].str.lower()

        title = df.copy(deep=True)
        title['Universidade'] = lowercase['Universidade'].str.title()

        lowercase_acronym = df.copy(deep=True)
        lowercase_acronym['Universidade'] = lowercase_acronym['Universidade'].str.lower() + ' ' + lowercase_acronym['SIGLA_IES']

        title_acronym = df.copy(deep=True)
        title_acronym['Universidade'] = title_acronym['Universidade'].str.title() + ' ' + title_acronym['SIGLA_IES']

        uppercase_acronym = df.copy(deep=True)
        uppercase_acronym['Universidade'] = uppercase_acronym['Universidade'].str.upper() + ' ' + uppercase_acronym['SIGLA_IES']

        final_df = pd.concat([
            df,
            uppercase,
            acronym,
            lowercase,
            title,
            lowercase_acronym,
            title_acronym,
            uppercase_acronym
        ], ignore_index=True)

        write_path = os.path.join(os.path.dirname(__file__), 'data', 'test_ies.csv')
        final_df.to_csv(
            write_path,
            sep=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC, encoding='utf-8',
            index=False
        )
        print(f'Planilha com casos de teste gerada em {write_path}')

if __name__ == '__main__':
    _path = os.path.join(os.path.dirname(__file__), '..', '..', 'instance', 'database_credentials.json')
    if not os.path.exists(_path):
        raise FileNotFoundError(
            'Esse script precisa de um arquivo de configurações'
            ' do banco de dados em instance/database_credentials.json'
        )
    main(_path)