import os
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
        "R_PILARES_VALORES, R_UNIVERSIDADES_APELIDOS, R_UNIVERSIDADES, e R_UNIVERSIDADES_PARA_GRUPOS. Insere "
        "universidades brasileiras primeiro com variações de nome (e.g. 'Universidade Federal de Santa Maria',"
        "'Universidade Federal de Santa Maria (UFSM)'"
    )

    def handle(self, *args, **options):
        _common = os.path.join(os.path.dirname(__file__), '..', '..', 'database', 'sql')

        sql_scripts = [
            os.path.join(_common, x) for x in [
                os.path.join('drop', 'soft_drop.sql'),
                os.path.join('create', 'soft_create.sql')
            ]
        ]

        run_several(connection, sql_scripts)
        soft_populate(connection)

        self.stdout.write(self.style.SUCCESS('Soft reset completado com sucesso!'))
