import io
import os

import pandas as pd
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase, TransactionTestCase
from django.urls import reverse
from ..models import Ranking, Pilar, Continente, Pais, ApelidoDePais, TipoApelido, IES
from django.apps import apps
from django.db import connection


class RankingInsertViewTestCase(TransactionTestCase):
    @classmethod
    def setUpClass(cls):
        """
        Executa uma vez só para a classe.
        """
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

        # insere ranking fake
        ranking = Ranking.objects.create(nome='Test Ranking')
        ranking.save()

        # insere pilares fake
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

        tipo_apelido_alternativo = TipoApelido.objects.create(tipo_apelido='Nome alternativo')
        tipo_apelido_alternativo.save()

        tipo_apelido_subdivisao = TipoApelido.objects.create(tipo_apelido='Subdivisão')
        tipo_apelido_subdivisao.save()

        # insere um continente fake
        continente = Continente.objects.create(nome_ingles='Test Continent', nome_portugues='Continente Teste')
        continente.save()

        # insere um país fake
        pais_teste = Pais.objects.create(nome_ingles='Test Country', nome_portugues='País Teste', continente=continente)
        pais_teste.save()

        apelido_pais_ingles = ApelidoDePais.objects.create(
            apelido='Test Country', pais=pais_teste, tipo_apelido=tipo_apelido_alternativo
        )
        apelido_pais_ingles.save()

        apelido_pais_portugues = ApelidoDePais.objects.create(
            apelido='País Teste', pais=pais_teste, tipo_apelido=tipo_apelido_alternativo
        )
        apelido_pais_portugues.save()

        # insere o brasil
        brasil = Pais.objects.create(nome_ingles='Brazil', nome_portugues='Brasil', continente=continente)
        brasil.save()

        apelido_pais_ingles = ApelidoDePais.objects.create(
            apelido='Brazil', pais=brasil, tipo_apelido=tipo_apelido_alternativo
        )
        apelido_pais_ingles.save()

        apelido_pais_portugues = ApelidoDePais.objects.create(
            apelido='Brasil', pais=brasil, tipo_apelido=tipo_apelido_alternativo
        )
        apelido_pais_portugues.save()



        # cria uma IES fake
        ies = IES.objects.create(
            cod_ies=1,
            sigla_ies='TU',
            nome_ies='Test University'
        )
        ies.save()

    def setUp(self):
        """
        Executa uma vez antes de cada método.
        """
        pass

    def test_correct_form(self):
        """
        Testa o envio de um formulário com informações preenchidas corretamente.
        """
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

        # faz uma requisição POST
        response = self.client.post(reverse('ranking-insert'), data, format='multipart', follow=True)

        # verifica resposta
        self.assertEqual(response.status_code, 200)  # 302 para redirecionamento

        # Optionally check if success message exists
        # self.assertContains(response, "success")  # adjust based on your success_insert_ranking output

