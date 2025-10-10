"""
Script para testes locais com SQLite em memória, não persistente, sem alterar o banco de produção.
"""

from .settings import *

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": ":memory:",
    }
}

del DATABASE_ROUTERS