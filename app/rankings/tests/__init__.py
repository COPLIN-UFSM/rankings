import io
import os
import pandas as pd

from django.apps import apps
from django.db import connection
from django.urls import reverse
from django.test import TransactionTestCase
from django.core.files.uploadedfile import SimpleUploadedFile

from ..forms import InsertRankingForm
from ..models import Ranking, Pilar, Continente, Pais, ApelidoDePais, TipoApelido, IES, Universidade, \
    ApelidoDeUniversidade, PilarValor, UltimaCarga
from ..scripts import get_document_pillars


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
        return data, df

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
    def test_missing_province(self):
        """
        Testa o envio de um formulário com uma província não-mapeada no banco de dados, mas que pode ser mapeada
        para um país existente no banco de dados.
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

        # verifica se os dados foram inseridos no banco
        self.assertEqual(PilarValor.objects.all().count(), 4)

        pillars = get_document_pillars(df=df, ranking=Ranking.objects.get(nome='Test Ranking'))

        for p in pillars:
            pv = PilarValor.objects.get(pilar_id=p['id_pilar'])
            self.assertAlmostEqual(df.iloc[0][p['Pilar']][0], pv.valor_inicial)

        self.assertEqual(UltimaCarga.objects.all().count(), 4)


class RankingsInsertViewTestCase(RankingsTransactionTestCase):
    def check_inserted_pillar_values(self, df):
        # verifica se os dados foram inseridos no banco
        self.assertEqual(PilarValor.objects.all().count(), 4)

        pillars = get_document_pillars(df=df, ranking=Ranking.objects.get(nome='Test Ranking'))

        for p in pillars:
            pv = PilarValor.objects.get(pilar_id=p['id_pilar'])
            self.assertAlmostEqual(df.iloc[0][p['Pilar']], pv.valor_inicial)

    def test_present_country_and_university(self):
        """
        Testa o envio de um formulário com informações preenchidas corretamente,
        e uma universidade já existente no banco.
        """
        # insere universidade no banco
        universidade = Universidade.objects.create(
            nome_ingles='Test University',
            nome_portugues='Universidade Teste',
            sigla='TU',
            pais_apelido=ApelidoDePais.objects.get(apelido='Test Country')
        )
        universidade.save()

        apelido = ApelidoDeUniversidade.objects.create(
            universidade=universidade,
            apelido='Test University'
        )
        apelido.save()

        data, df = RankingsInsertViewTestCase.get_form_data('test_ranking_01.csv')

        # faz uma requisição POST
        response = self.client.post(reverse('ranking-insert'), data, format='multipart', follow=True)

        # verifica resposta
        self.assertEqual(response.status_code, 200)  # 302 para redirecionamento

        # verifica se a mensagem de sucesso está na resposta
        self.assertContains(response, "Sucesso")

        self.check_inserted_pillar_values(df)

        self.assertEqual(UltimaCarga.objects.all().count(), 1)

    def test_missing_university(self):
        """
        Testa o envio de um formulário com informações preenchidas corretamente, porém sem a universidade inserida
        no banco de dados.
        """
        data, df = RankingsInsertViewTestCase.get_form_data('test_ranking_01.csv')

        # faz uma requisição POST
        response = self.client.post(reverse('ranking-insert'), data, format='multipart', follow=True)

        # verifica resposta
        self.assertEqual(response.status_code, 200)  # 302 para redirecionamento

        # verifica se a mensagem de sucesso está na resposta
        self.assertContains(response, "Sucesso")

        # verifica se os dados foram inseridos no banco
        self.check_inserted_pillar_values(df)

        # verifica se universidade foi inserida
        Universidade.objects.get(nome_ingles='Test University')  # lança uma exceção se não existir
        ApelidoDeUniversidade.objects.get(apelido='Test University')  # lança uma exceção se não existir

        self.assertEqual(UltimaCarga.objects.all().count(), 3)


    def test_ies_correlation(self):
        """
        Testa o envio de um formulário com informações preenchidas corretamente, porém sem uma universidade,
        e esta universidade mapeia para uma IES no banco de dados.
        """
        data, df = RankingsInsertViewTestCase.get_form_data('test_ranking_03.csv')

        # faz uma requisição POST
        response = self.client.post(reverse('ranking-insert'), data, format='multipart', follow=True)

        # verifica resposta
        self.assertEqual(response.status_code, 200)  # 302 para redirecionamento

        # verifica se a mensagem de sucesso está na resposta
        self.assertContains(response, "Sucesso")

        self.check_inserted_pillar_values(df)

        # verifica se universidade foi inserida
        Universidade.objects.get(nome_ingles='Test University')  # lança uma exceção se não existir
        ApelidoDeUniversidade.objects.get(apelido='Test University')  # lança uma exceção se não existir

        # verifica se a universidade está relacionada com a IES correta
        self.assertEqual(ApelidoDeUniversidade.objects.get(apelido='Test University').universidade.cod_ies, 1)

        self.assertEqual(UltimaCarga.objects.all().count(), 3)

    def test_missing_province(self):
        """
        Testa o envio de um formulário com uma província não-mapeada no banco de dados.
        """
        data, df = RankingsInsertViewTestCase.get_form_data('test_ranking_02.csv')

        # faz uma requisição POST
        response = self.client.post(reverse('ranking-insert'), data, format='multipart', follow=True)

        # verifica resposta
        self.assertEqual(response.status_code, 200)  # 302 para redirecionamento

        # verifica se o texto está contido no HTML da página HTML carregada
        self.assertContains(response, 'Verificar países faltantes')