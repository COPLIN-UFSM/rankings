import os
import re
import sys

from django.core.management.base import BaseCommand
from django.db import connection

try:
    from app.rankings.database.scripts import soft_populate, run_several
except ImportError:
    from rankings.database.scripts import soft_populate, run_several

class Command(BaseCommand):
    help = (
        "Soft reset: remove apenas dados das tabelas "
        "R_PILARES_VALORES, R_UNIVERSIDADES_APELIDOS, R_UNIVERSIDADES_PARA_GRUPOS, e R_UNIVERSIDADES. Insere "
        "universidades brasileiras primeiro com variações de nome (e.g. 'Universidade Federal de Santa Maria',"
        "'Universidade Federal de Santa Maria (UFSM)'"
    )

    def handle(self, *args, **options):
        _common = os.path.join(os.path.dirname(__file__), '..', '..', 'database', 'sql')

        files = [
            'pilares_valores.sql', 'universidades_para_grupos.sql',
            'universidades_apelidos.sql', 'universidades.sql'
        ]

        for mode in ['drop', 'create']:
            folder_files = os.listdir(os.path.join(_common, mode))
            selected = sorted([os.path.join(_common, mode, x) for x in folder_files if any([y in x for y in files])])
            run_several(connection, selected)

        soft_populate(connection)

        print('Soft reset completado com sucesso!')
