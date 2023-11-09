import sqlparse
import argparse
import os

from sqlparse.sql import Identifier


def main(parameter):
    read_path = '.'
    with open(os.path.join(read_path, 'ibmdb_create.sql'), 'r') as read_file:
        sql = read_file.read()

    parsed = sqlparse.parse(sql)
    creates = [x for x in parsed if x.get_type() == 'CREATE']
    for c in creates:
        for t in c.tokens:  # type: Identifier
            z = 0


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Descrição do script.'
    )

    parser.add_argument(
        '--parameter', action='store', required=False,
        help='Algum parâmetro.'
    )

    args = parser.parse_args()
    main(args.parameter)
