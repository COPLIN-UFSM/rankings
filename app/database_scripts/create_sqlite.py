import argparse
import os
import re
import sqlite3


def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


def from_ibmdb_to_sqlite(read_path, db_name):
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

    if os.path.exists(os.path.join(read_path, db_name)):
        os.remove(os.path.join(read_path, db_name))


def create_sqlite_database(read_path, db_name):
    with sqlite3.Connection(db_name) as conn, open(os.path.join(read_path, 'sqlite_create.sql'), 'r') as read_file:
        statements = read_file.read().split('\n\n')

        cursor = conn.cursor()

        for stat in statements:
            cursor.execute(stat)


def create_mermaid_graph(read_path, db_name):
    with sqlite3.Connection(db_name) as conn, open(os.path.join(read_path, 'SCHEMA.md'), 'w') as write_file:
        conn.row_factory = dict_factory
        cursor = conn.cursor()

        tables = cursor.execute('''
            select distinct(tbl_name) 
            from sqlite_master 
            where tbl_name not like '%sqlite%';
        ''').fetchall()

        code = {'relationships': [], 'tables': []}
        for table in tables:
            table_name = table["tbl_name"]

            query_columns = cursor.execute(f'''PRAGMA table_info({table["tbl_name"]});''').fetchall()
            code['tables'] += [
                f'class {table_name} {{\n' + '\n'.join([f'{" " * 8}{x["type"]} {x["name"]}' for x in query_columns])
            + '\n    }']

            matches = cursor.execute(f'''
                SELECT * 
                FROM pragma_foreign_key_list('{table_name}');
            ''').fetchall()

            for match in matches:
                code['relationships'] += [f'{table_name} --> {match["table"]} : {match["to"]}']

        write_file.write('```mermaid\nclassDiagram\n')
        write_file.write('\n'.join(['    ' + k for k in code['tables']]))
        write_file.write('\n\n')
        for v in code['relationships']:
            write_file.write(f'    {v}\n')
        write_file.write('```')


def main():
    read_path = '..'
    db_name = 'sqlite_model.db'
    from_ibmdb_to_sqlite(read_path, db_name)
    create_sqlite_database(read_path, db_name)
    create_mermaid_graph(read_path, db_name)


if __name__ == '__main__':
    main()
