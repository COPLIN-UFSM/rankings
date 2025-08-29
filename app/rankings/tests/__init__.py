import io
import os

import pandas as pd
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase, TransactionTestCase
from django.urls import reverse
from ..models import Ranking, Pilar
from django.apps import apps
from django.db import connection


class RankingInsertViewTestCase(TransactionTestCase):
    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        # Force all unmanaged models to become managed in tests
        for model in apps.get_models():
            if not model._meta.managed:
                model._meta.managed = True

                # Create their table in the test DB
                with connection.schema_editor() as schema_editor:
                    try:
                        schema_editor.create_model(model)
                    except Exception:
                        # Ignore if table already exists
                        pass

    def setUp(self):
        ranking = Ranking.objects.create(nome="Test Ranking")
        ranking.save()

        pillars = [
            ('Sample Pillar 1 (Score)', 'Pilar de Exemplo 1 (Score)'),
            ('Sample Pillar 1 (Rank)', 'Pilar de Exemplo 1 (Rank)'),
            ('Sample Pillar 2 (Score)', 'Pilar de Exemplo 2 (Score)'),
            ('Sample Pillar 2 (Rank)', 'Pilar de Exemplo 2 (Rank)'),
        ]
        for (nome_pilar_ingles, nome_pilar_portugues) in pillars:
            pilar = Pilar.objects.create(
                ranking=ranking,
                nome_ingles=nome_pilar_ingles,
                nome_portugues=nome_pilar_portugues
            )
            pilar.save()

    def test_correct_form(self):
        # Create a sample CSV in memory
        filename = 'test_ranking_01.csv'

        df = pd.read_csv(
            os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', filename)
        )
        csv_buffer = io.StringIO()
        df.to_csv(csv_buffer, index=False)
        csv_buffer.seek(0)

        # Wrap it as an uploaded file
        uploaded_file = SimpleUploadedFile(
            filename,
            csv_buffer.getvalue().encode('utf-8'),
            content_type="text/csv"
        )

        ranking = Ranking.objects.get(nome='Test Ranking')

        # prepara dados do formulário
        data = {
            'ranking': ranking.pk,
            'file': uploaded_file
        }

        # Make POST request
        response = self.client.post(reverse('ranking-insert'), data, format='multipart')

        # Check response
        self.assertEqual(response.status_code, 200)  # or 302 if your view redirects on success

        # Optionally check if success message exists
        self.assertContains(response, "success")  # adjust based on your success_insert_ranking output

