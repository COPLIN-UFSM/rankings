import argparse
import os
import re
import sqlite3


def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


def main():
    read_path = '.'
    with open(os.path.join(read_path, 'ibmdb_create.sql'), 'r') as read_file, \
            open(os.path.join(read_path, 'sqlite_create.sql'), 'w') as write_file:
        sql = read_file.read()

        sql = sql.replace('GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1)', 'AUTOINCREMENT')
        matches = re.findall('VARCHAR\([0-9]+\)', sql)
        for match in matches:
            sql = sql.replace(match, 'TEXT')

        matches = re.findall('COMMENT (?:.*?);', sql)
        for match in matches:
            sql = sql.replace(match, '')

        _index = sql.index('INSERT INTO')
        creates = sql[:_index]
        inserts = sql[_index:].split('\n\n')

        write_file.write(creates)

        # for insert in inserts:
        #     insert = insert.replace('\n', '')
        #     head = insert[:insert.index('VALUES') + len('VALUES')] + ' '
        #     matches = re.findall('\(.*?\)', insert)[1:]
        #     for match in matches:
        #         match = match.replace(match, head + match + ';\n')
        #         write_file.write(match)

    db_name = 'database_sqlite_v2.db'
    if os.path.exists(os.path.join(read_path, db_name)):
        os.remove(os.path.join(read_path, db_name))

    with sqlite3.Connection(db_name) as conn, \
            open(os.path.join(read_path, 'sqlite_create.sql'), 'r') as read_file, \
            open(os.path.join(read_path, 'schema.md'), 'w') as write_file:
        conn.row_factory = dict_factory

        statements = read_file.read().split('\n\n')

        cursor = conn.cursor()

        for stat in statements:
            cursor.execute(stat)

        tables = cursor.execute('''
            select distinct(tbl_name) from sqlite_master where tbl_name not like '%sqlite%';
        ''').fetchall()

        code = dict()
        for table in tables:
            table_name = table["tbl_name"]
            matches = cursor.execute(f'''
            SELECT * FROM pragma_foreign_key_list('{table_name}');
            ''').fetchall()

            code[table_name] = list()

            for match in matches:
                code[table_name] += [f'{table_name} -- {match["to"]} --> {match["table"]}']

        write_file.write('```mermaid\nflowchart TD\n')
        write_file.write('\n'.join(['    ' + k for k in code.keys()]))
        write_file.write('\n\n')
        for v in code.values():
            for p in v:
                write_file.write(f'    {p}\n')
        write_file.write('```')


if __name__ == '__main__':
    main()
