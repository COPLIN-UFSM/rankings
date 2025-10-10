"""
Script para testes locais com SQLite persistente em disco, sem alterar o banco de produção.
"""

import django
from django.apps import apps
from django.db import connection

from .settings import *

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "dev.sqlite3",  # ou um caminho absoluto se quiser
    }
}

del DATABASE_ROUTERS

def force_create_unmanaged_models():
    """
    Cria tabelas para modelos com managed=False (útil em dev com SQLite).
    """
    django.setup()
    for model in apps.get_models():
        if not model._meta.managed:
            model._meta.managed = True
            with connection.schema_editor() as schema_editor:
                try:
                    schema_editor.create_model(model)
                    print(f"  [OK] Modelo criado: {model.__name__}")
                except Exception as e:
                    print(f"[WARN] Não foi possível criar o modelo {model.__name__}: {e}")

# Executa automaticamente, mas só se o banco ainda não existir
if not os.path.exists(DATABASES["default"]["NAME"]):
    print("[INFO] dev.sqlite3 não encontrado - criando tabelas do banco de dados")
    force_create_unmanaged_models()