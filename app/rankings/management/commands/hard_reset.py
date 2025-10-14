import os
import sys

from django.core.management.base import BaseCommand
from django.db import connection

try:
    from app.rankings.database.scripts import drop_all_tables, create_all_tables, populate_all_tables
except ImportError:
    from rankings.database.scripts import drop_all_tables, create_all_tables, populate_all_tables

class Command(BaseCommand):
    help = (
        "Hard reset: remove todas as tabelas de rankings do banco e dados, recria-as e repopula com as tuplas originais."
    )

    def handle(self, *args, **options):
        drop_all_tables(connection)
        create_all_tables(connection)
        populate_all_tables(connection)

        self.stdout.write(self.style.SUCCESS('Hard reset completado com sucesso!'))
