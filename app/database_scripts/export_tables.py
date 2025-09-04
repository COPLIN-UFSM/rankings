"""
Script para extrair dados das tabelas desta aplicação para arquivos csv.
"""
import re
import os
import csv
import argparse

from tqdm import tqdm
from db2 import DB2Connection


def main(database_credentials, dump_path):
    with open('default_create.sql', 'r', encoding='utf-8') as read_file:
        contents = read_file.read()

    tables = re.findall('CREATE TABLE ([\w_]+)', contents)

    with DB2Connection(database_credentials) as conn:
        for table in tqdm(tables, desc='Exportando tabelas para csv'):
            df = conn.query_to_dataframe(f'SELECT * FROM {table}')
            df.to_csv(
                os.path.join(dump_path, f'{table}.csv'),
                sep=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC, index=False, encoding='utf-8'
            )


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Descrição do script.'
    )

    parser.add_argument(
        '--database-credentials', action='store', required=True,
        help='Caminho para um arquivo com as credenciais do banco de dados'
    )

    parser.add_argument(
        '--dump-path', action='store', required=True,
        help='Caminho onde escrever os arquivos csv com os dados das tabelas.'
    )

    args = parser.parse_args()
    main(database_credentials=args.database_credentials, dump_path=args.dump_path)
