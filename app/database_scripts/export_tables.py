"""
Script para extrair dados das tabelas desta aplicação para arquivos csv.
"""
import argparse
import csv
import os

from db2 import DB2Connection
import pandas as pd
from tqdm import tqdm


def main(database_credentials, dump_path):
    tables = [
        'R_CONTINENTES',
        'R_PAISES',
        'R_PAISES_APELIDOS_TIPOS',
        'R_PAISES_APELIDOS',
        'R_GRUPOS_GEOPOLITICOS',
        'R_PAISES_PARA_GRUPOS_GEOPOLITICOS',
        'R_UNIVERSIDADES',
        'R_UNIVERSIDADES_PARA_IES',
        'R_UNIVERSIDADES_APELIDOS',
        'R_UNIVERSIDADES_GRUPOS',
        'R_UNIVERSIDADES_PARA_GRUPOS',
        'R_RANKINGS',
        'R_PILARES',
        'R_METRICAS',
        'R_PILARES_PARA_GRUPOS',
        'R_METRICAS_PARA_PILARES',
        'R_METRICAS_VALORES',
        'R_TIPOS_METADADOS',
        'R_TIPOS_ENTIDADES',
        'R_METADADOS',
        'R_FORMULARIOS',
        'R_PILARES_VALORES'
    ]

    with DB2Connection(database_credentials) as conn:
        for table in tqdm(tables, desc='Exportando tabelas para csv'):
            df = conn.query_to_dataframe(F'SELECT * FROM {table}')
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
