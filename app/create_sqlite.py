import sqlparse
import argparse
import os
from functools import reduce
import operator as op


class Table(object):
    def __init__(self, name, columns):
        self.name = name
        self.columns = columns


class Column(object):
    def __init__(self, name, dbtype, keywords):
        self.name = name
        self.dbtype = dbtype
        self.keywords = keywords

    def __str__(self):
        return f'{self.name} {self.dbtype} {" ".join(self.keywords)}'

    def __repr__(self) -> str:
        return str(self)


class ParseCreateStatement(object):
    def __init__(self, creates):
        inside_create = False

        for c in creates:
            subs = list(c.get_sublists())
            for sub in subs:
                if isinstance(sub, sqlparse.sql.Identifier) and not inside_create:
                    table_name = sub.get_name()
                    inside_create = True
                elif isinstance(sub, sqlparse.sql.Parenthesis) and inside_create:
                    columns = self.parse_columns(sub.tokens)

    def parse_columns(self, tokens):
        columns = []
        inside_column = False
        name = None
        dbtype = None
        keywords = []

        tokens = list(reduce(op.add, map(lambda x: list(x.flatten()), tokens)))

        for token in tokens:
            if token.ttype is not None:
                if 'Name' in list(token.ttype):
                    if 'Builtin' in list(token.ttype):
                        dbtype = token.value
                    else:
                        if not inside_column:
                            inside_column = True
                        else:
                            # wraps what found so far
                            columns += [Column(name, dbtype, keywords)]
                            dbtype = None
                            keywords = []

                        name = token.value
                elif 'Keyword' in list(token.ttype):
                    keywords += [token.value]

            # elif token.is_keyword:
            #         keywords += [token.value]


        columns += [Column(name, dbtype, keywords)]

        return columns


def main(parameter):
    read_path = '.'
    with open(os.path.join(read_path, 'ibmdb_create.sql'), 'r') as read_file:
        sql = read_file.read()

    parsed = sqlparse.parse(sql)
    creates = [x for x in parsed if x.get_type() == 'CREATE']
    tables = ParseCreateStatement(creates)


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
