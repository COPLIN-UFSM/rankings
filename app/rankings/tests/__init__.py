import io
import os
import pandas as pd

from django.apps import apps
from django.db import connection
from django.urls import reverse
from django.test import TransactionTestCase
from django.core.files.uploadedfile import SimpleUploadedFile

from ..forms import InsertRankingForm
from ..models import Ranking, Pilar, Continente, Pais, ApelidoDePais, TipoApelido, IES


class RankingsTransactionTestCase(TransactionTestCase):
    @staticmethod
    def get_form_data(filename):
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
            'ranking': ranking.id_ranking,
            'file': uploaded_file
        }
        return data

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


    def setUp(self):
        """
        Insere uma vez por método.
        """
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

class MissingCountriesPreviewTestCase(RankingsTransactionTestCase):
    def test_missing_province_form(self):
        """
        Testa o envio de um formulário com uma província não-mapeada no banco de dados.
        """

        apelido_pais = ApelidoDePais.objects.get(apelido='Test Country')
        pais = apelido_pais.pais

        ranking = Ranking.objects.get(nome='Test Ranking')

        df = pd.read_csv(
            os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'test_ranking_02.csv')
        )

        df = InsertRankingForm.check_ranking_file_consistency(df, ranking)

        session = self.client.session
        session['df'] = df.to_json()
        session['id_ranking'] = ranking.id_ranking
        session.save()

        data = {
            'country-name-0': str(df.iloc[0]['País']),
            'select-country-0': str(pais.id_pais),
            'select-type-0': str(apelido_pais.tipo_apelido.id_tipo_apelido)
        }

        # faz uma requisição POST
        response = self.client.post(reverse('missing-countries-preview'), data, follow=True)

        # verifica resposta
        self.assertEqual(response.status_code, 200)  # 302 para redirecionamento

        # verifica se a mensagem de sucesso está na resposta
        self.assertContains(response, 'Sucesso')


class RankingsInsertViewTestCase(RankingsTransactionTestCase):
    def test_correct_form(self):
        """
        Testa o envio de um formulário com informações preenchidas corretamente.
        """
        data = RankingsInsertViewTestCase.get_form_data('test_ranking_01.csv')

        # faz uma requisição POST
        response = self.client.post(reverse('ranking-insert'), data, format='multipart', follow=True)

        # verifica resposta
        self.assertEqual(response.status_code, 200)  # 302 para redirecionamento

        # verifica se a mensagem de sucesso está na resposta
        self.assertContains(response, "Sucesso")

    def test_missing_province_form(self):
        """
        Testa o envio de um formulário com uma província não-mapeada no banco de dados.
        """
        data = RankingsInsertViewTestCase.get_form_data('test_ranking_02.csv')

        # faz uma requisição POST
        response = self.client.post(reverse('ranking-insert'), data, format='multipart', follow=True)

        # verifica resposta
        self.assertEqual(response.status_code, 200)  # 302 para redirecionamento

        # verifica se o texto está contido no HTML da página HTML carregada
        self.assertContains(response, 'Verificar países faltantes')
