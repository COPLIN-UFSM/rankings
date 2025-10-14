import os
import csv

import pandas as pd
from db2 import DB2Connection


def main(path):
    with DB2Connection(path) as conn:
        df = conn.query_to_dataframe('''
            select 
                COD_IES, 
                coalesce(SIGLA_IES, '') as SIGLA_IES, 
                NOME_IES as "Universidade",
                'Brasil' as "País",
                2025 AS "Ano",
                1 as "Sample Pillar 1 (Score)",
                2 as "Sample Pillar 1 (Rank)",
                3 as "Sample Pillar 2 (Score)",
                4 as "Sample Pillar 2 (Rank)"
            from IES;
        ''')

        variations = {
            "title_acronym": lambda d: d["Universidade"].str.title() + " " + d["SIGLA_IES"],
            "title_parenthesis": lambda d: d["Universidade"].str.title() + " (" + d["SIGLA_IES"] + ")",
            "title_hyphen": lambda d: d["Universidade"].str.title() + " - " + d["SIGLA_IES"],
        }

        initial = df.copy(deep=True)
        initial['Universidade'] = initial['Universidade'].str.title()
        dfs = [initial]

        for name, func in variations.items():
            temp = df.copy(deep=True)
            temp["Universidade"] = func(temp)
            temp = temp.loc[(~pd.isna(temp['SIGLA_IES'])) & (~temp['SIGLA_IES'].str.strip().eq(''))]
            dfs.append(temp)

        final_df = pd.concat(dfs, ignore_index=True)

        flipped = final_df.copy(deep=True)
        flipped["País"] = "Test Country"
        final_df = pd.concat([final_df, flipped], ignore_index=True)

        write_path = os.path.join(os.path.dirname(__file__), "data", "test_ies.csv")
        final_df.to_csv(
            write_path,
            sep=",", quotechar='"', quoting=csv.QUOTE_NONNUMERIC, encoding="utf-8",
            index=False
        )
        print(f"Planilha com casos de teste gerada em {write_path}")

if __name__ == '__main__':
    _path = os.path.join(os.path.dirname(__file__), '..', '..', 'instance', 'database_credentials.json')
    if not os.path.exists(_path):
        raise FileNotFoundError(
            'Esse script precisa de um arquivo de configurações'
            ' do banco de dados em instance/database_credentials.json'
        )
    main(_path)