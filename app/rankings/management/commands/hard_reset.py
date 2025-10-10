import os
import sys

from django.core.management.base import BaseCommand
from django.db import connection

try:
    from app.rankings.database.scripts import hard_reset
except ImportError:
    from rankings.database.scripts import hard_reset

class Command(BaseCommand):
    help = (
        "Hard reset: remove todas as tabelas de rankings do banco e dados, recria-as e repopula com as tuplas originais."
    )

    def handle(self, *args, **options):
        hard_reset(connection)

        self.stdout.write(self.style.SUCCESS('Hard reset completado com sucesso!'))
