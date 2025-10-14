import itertools as it
import re
import sys
from io import StringIO

import numpy as np
import pandas as pd
from django.contrib import messages
from django.core.exceptions import ValidationError, PermissionDenied
from django.shortcuts import render, redirect
from django.urls import reverse
from django.utils import timezone
from django.views.generic import TemplateView
from sentence_transformers import SentenceTransformer
from tqdm import tqdm

from .forms import InsertRankingForm
from .models import PilarValor, Ranking, TipoApelido, Pais, ApelidoDeUniversidade, IES
from .models import Universidade, ApelidoDePais
from .scripts import get_canonical_name, get_all_db_universities, get_closest_match, get_all_ies, get_document_pillars, \
    update_ultima_carga


class IndexView(TemplateView):
    template_name = 'rankings/index.html'

    def get(self, request, *args, **kwargs):
        n_universidades = Universidade.objects.count()

        n_distinct_countries = (
            PilarValor.objects
            .values('apelido_universidade__universidade__pais_apelido__pais__id_pais')
            .distinct()
            .count()
        )

        n_pillars = (
            PilarValor.objects
            .values('pilar__id_pilar')
            .distinct()
            .count()
        )

        n_rankings = (
            PilarValor.objects
            .values('pilar__ranking__id_ranking')
            .distinct()
            .count()
        )

        n_pillar_values = PilarValor.objects.count()

        context = {
            'display_greetings': True,
            'information_list': [
                {'name': 'universidade' + ('s' if n_universidades != 1 else ''), 'value': n_universidades},
                {'name': 'país' + ('es' if n_distinct_countries != 1 else ''), 'value': n_distinct_countries},
                {'name': 'ranking' + ('s' if n_rankings != 1 else ''), 'value': n_rankings},
                {'name': 'pilar' + ('es' if n_pillars != 1 else ''), 'value': n_pillars},
                {'name': 'valores de pilar' + ('es' if n_pillar_values != 1 else ''), 'value': n_pillar_values},
            ]
        }
        return render(request, 'rankings/index.html', context)


class SuccessInsertRankingView(TemplateView):
    template_name = 'rankings/ranking/insert/success.html'

    @staticmethod
    def __append_row__(i, row, pillars):
        to_add_pillars = []

        for pillar in pillars:
            nome_pilar = pillar['Pilar']
            id_pilar = pillar['id_pilar']

            try:
                p_values = eval(row[nome_pilar])  # converte para uma lista
            except TypeError:
                p_values = row[nome_pilar]  # já é uma lista

            pilar_valor = PilarValor(
                apelido_universidade_id=int(row['id_apelido_universidade']),
                pilar_id=int(id_pilar),
                ano=int(row['Ano']),
                valor_inicial=p_values[0],
                valor_final=p_values[1],
            )
            to_add_pillars += [pilar_valor]

        return to_add_pillars

    @staticmethod
    def insert_ranking_data(df: pd.DataFrame, ranking: Ranking, batch_size: int = 500):
        """
        Insere os dados do formulário nas tabelas pertinentes.

        :param df: um formulário, com id_universidade e id_pais definido para todas as linhas.
        :param ranking: Um objeto do tipo Ranking, que refere-se ao ranking que está sendo inserido.
        :param batch_size: opcional - o número de tuplas a serem inseridas com um comando INSERT no banco de dados. O padrão
            é 999.
        """
        # verifica colunas básicas
        if 'id_apelido_universidade' not in df.columns:
            raise ValidationError(f'A planilha deve conter uma coluna de nome \'id_apelido_universidade\'!')
        if 'Ano' not in df.columns:
            raise ValidationError(f'A planilha deve conter uma coluna de nome \'Ano\'!')

        df['id_universidade'] = df['id_universidade'].astype(int)
        df['id_apelido_universidade'] = df['id_apelido_universidade'].astype(int)

        pillars = get_document_pillars(df, ranking=ranking)

        db_pillar_values = pd.DataFrame(
            PilarValor.objects.filter(pilar__ranking=ranking).values_list(
                'apelido_universidade_id', 'pilar_id', 'ano'
            ),
            columns=['id_apelido_universidade', 'id_pilar', 'ano']
        )

        to_add_pillars = []
        for i, row in tqdm(df.iterrows(), total=len(df), desc='Preparando dados para inserção'):
            to_add_pillars.extend(SuccessInsertRankingView.__append_row__(i, row, pillars))

        df_pillar_values = pd.DataFrame(
            [(x.apelido_universidade_id, x.pilar_id, x.ano) for x in to_add_pillars],
            columns=['id_apelido_universidade', 'id_pilar', 'ano']
        )

        merged = pd.merge(
            df_pillar_values,
            db_pillar_values,
            on=['id_apelido_universidade', 'id_pilar', 'ano'],
            how='left',
            indicator=True
        )

        assert len(merged) == len(to_add_pillars), 'O tamanho das variáveis não é igual!'

        filtered_pillars = list(it.compress(
            to_add_pillars,
            (merged['_merge'] == 'left_only').values.tolist()
        ))

        if len(filtered_pillars) > 0:
            print('Inserindo valores de pilares no banco de dados (isto pode demorar!)', file=sys.stderr)
            inserted_pillars = PilarValor.objects.bulk_create(
                filtered_pillars,
                batch_size=batch_size,
                ignore_conflicts=True
            )
            inserted_pillars = len(inserted_pillars)

            # inserted_pillars = 0
            # for pillar in tqdm(filtered_pillars, total=len(filtered_pillars), desc='Inserindo valores de pilares'):
            #     pillar.save()
            #     inserted_pillars += 1

        else:
            inserted_pillars = 0

        # print(f'{len(inserted_pillars)} linhas foram inseridas no banco de dados', file=sys.stderr)
        print(f'{inserted_pillars} linhas foram inseridas no banco de dados', file=sys.stderr)

        update_ultima_carga(
            'R_PILARES_VALORES',
            'Valores de pilares de rankings acadêmicos'
        )

        ranking.ultima_atualizacao = timezone.now()
        ranking.save()

        return inserted_pillars

    @staticmethod
    def fetch_cod_ies(uni_name):
        try:
            ies = IES.objects.get(nome_ies__iexact=uni_name)
            return ies.cod_ies
        except IES.DoesNotExist:
            return None

    @staticmethod
    def insert_id_university(df: pd.DataFrame) -> pd.DataFrame:
        def __prepare__(dfa, encode, decode, clear=False):
            if clear:
                dfa['id_universidade'] = np.nan
                dfa['id_apelido_universidade'] = np.nan

            dfa.loc[:, 'id_universidade'] = dfa['id_universidade'].astype(float)
            dfa.loc[:, 'id_pais'] = dfa['id_pais'].astype(float)
            dfa.loc[:, 'id_apelido_universidade'] = dfa['id_apelido_universidade'].astype(float)

            dfa['Universidade'] = dfa['Universidade'].str.strip()
            dfa['Universidade_ls'] = dfa['Universidade'].str.lower()

            return dfa

        if 'Universidade' not in df.columns:
            raise ValidationError('A coluna \'Universidade\' precisa estar no DataFrame!')
        if 'id_pais' not in df.columns:
            raise ValidationError('A coluna \'id_pais\' precisa estar no DataFrame!')
        if 'id_apelido_pais' not in df.columns:
            raise ValidationError('A coluna \'id_apelido_pais\' precisa estar no DataFrame!')

        # bd_unis possui as universidades do banco de dados
        db = get_all_db_universities()

        df = __prepare__(df, 'unicode_escape', 'latin-1', clear=True)
        db = __prepare__(db, 'latin-1', 'latin-1', clear=False)

        # joined = pd.merge(df, db, on=['Universidade_encoded', 'id_pais'], how='left', suffixes=('', '_db'))
        joined = pd.merge(df, db, on=['Universidade', 'id_pais'], how='left', suffixes=('', '_db'))

        joined.loc[joined.index, 'id_universidade_temp'] = joined.loc[joined.index, 'id_universidade_db']
        joined.loc[joined.index, 'id_apelido_universidade_temp'] = joined.loc[joined.index, 'id_apelido_universidade_db']

        # esse bloco evita um warning de incompatibilidade de tipos entre colunas
        joined = joined.drop(columns=['id_universidade', 'id_apelido_universidade'])

        joined.loc[joined.index, 'id_universidade'] = joined.loc[joined.index, 'id_universidade_temp']
        joined.loc[joined.index, 'id_apelido_universidade'] = joined.loc[joined.index, 'id_apelido_universidade_temp']

        df = joined[df.columns]

        update_apelido_uni = False
        update_uni = False

        # se alguma universidade do arquivo do ranking anda não tem o id_universidade setado
        if pd.isna(df['id_apelido_universidade']).any():
            id_pais_brasil = Pais.objects.filter(nome_portugues__iexact='Brasil').first().id_pais

            missing = df.loc[
                pd.isna(df['id_apelido_universidade'])
            ]
            # .drop_duplicates(
            #     subset=['Universidade', 'id_pais']
            # ))

            gb = missing.groupby(['Universidade_ls', 'id_pais'])

            for uni_name_lowercase, index in tqdm(gb.groups.items(), total=len(gb.groups.items()), desc='Inserindo universidades no banco'):
                rows = gb.get_group(uni_name_lowercase)
                id_pais = rows.iloc[0]['id_pais']
                id_apelido_pais = int(rows.iloc[0]['id_apelido_pais'])

                # se for uma universidade brasileira, tenta achar uma correspondência na tabela IES
                if id_pais == id_pais_brasil:
                    cod_ies = rows['Universidade'].apply(SuccessInsertRankingView.fetch_cod_ies)
                    if (~pd.isna(cod_ies)).any():
                        cod_ies = cod_ies.loc[~pd.isna(cod_ies)].iloc[0]
                    else:
                        cod_ies = None
                else:
                    cod_ies = None

                universidade = Universidade(
                    nome_portugues=rows.iloc[0]['Universidade'],
                    nome_ingles=rows.iloc[0]['Universidade'],
                    cod_ies=cod_ies,
                    pais_apelido_id=id_apelido_pais
                )
                universidade.save()

                gba = rows.groupby(by='Universidade')

                for alias, i in gba.groups.items():
                    apelido = ApelidoDeUniversidade(
                        universidade=universidade,
                        apelido=alias
                    )
                    apelido.save()

                    df.loc[i, 'id_universidade'] = universidade.id_universidade
                    df.loc[i, 'id_apelido_universidade'] = apelido.id_apelido

                update_uni = True
                update_apelido_uni = True

        if update_uni:
            update_ultima_carga(
                'R_UNIVERSIDADES',
                'Tabela com relação de universidades de rankings acadêmicos'
            )

        if update_apelido_uni:
            update_ultima_carga(
                'R_UNIVERSIDADES_APELIDOS',
                'Apelidos de universidades de rankings acadêmicos'
            )

        if df[['id_apelido_universidade', 'id_universidade']].isna().any(axis='index').any():
            raise ValidationError(
                'Algumas universidades não tiveram seu id_universidade ou id_apelido_universidade definido!'
            )

        return df

    def get(self, request, *args, **kwargs):
        ranking, df = get_dataframe_from_session(request)

        df = SuccessInsertRankingView.insert_id_university(df)
        n_inserted_rows = SuccessInsertRankingView.insert_ranking_data(df, ranking=ranking)

        remove_dataframe_and_ranking_from_session(request)

        return render(
            request,
            'rankings/ranking/insert/success.html',
            context={
                'n_inserted_rows': n_inserted_rows,
                'ranking_name': ranking.nome,
            }
        )

    def post(self, request, *args, **kwargs):
        raise PermissionDenied()  # TODO debugging purposes
        # ranking, df = get_dataframe_from_session(request)
        #
        # SuccessInsertRankingView.insert_ranking_data(df, ranking=ranking)
        #
        # return render(request, 'rankings/ranking/insert/success.html')


def get_dataframe_from_session(request):
    df_json = request.session.get('df')
    id_ranking = request.session.get('id_ranking')
    if (df_json is None) or (id_ranking is None):
        raise PermissionDenied()

    df = pd.read_json(StringIO(df_json))
    ranking = Ranking.objects.get(id_ranking=id_ranking)
    return ranking, df

def remove_dataframe_and_ranking_from_session(request):
    request.session.pop('df', None)
    request.session.pop('id_ranking', None)

class MissingCountriesPreview(TemplateView):
    template_name = "rankings/countries/missing/preview.html"

    @staticmethod
    def insert_id_pais(df: pd.DataFrame) -> pd.DataFrame:
        """
        Dado um dataframe que é a coleta de um ranking feita pela internet,
        insere o id_pais e o id_apelido_pais para cada linha.
        """

        def __prepare__(_df, set_pais=True, set_apelido=True):
            if set_pais:
                _df['id_pais'] = np.nan
            if set_apelido:
                _df['id_apelido_pais'] = np.nan

            _df['id_pais'] = _df['id_pais'].astype('Int64')
            _df['id_apelido_pais'] = _df['id_apelido_pais'].astype('Int64')

            _df['País (canonical)'] = _df['País'].apply(lambda x: hash(get_canonical_name(str(x)))).astype('Int64')
            return _df

        if 'País' not in df.columns:
            raise ValidationError('A coluna \'País\' precisa estar no DataFrame!')

        original_columns = df.columns.tolist()

        df = __prepare__(df, set_pais=True, set_apelido=True)

        mapping = {
            'pais_id': 'id_pais',
            'id_apelido': 'id_apelido_pais',
            'apelido': 'País'
        }
        db = pd.DataFrame(ApelidoDePais.objects.all().values(*mapping.keys()))
        if len(db) == 0:
            db = pd.DataFrame(columns=list(mapping.values()))
        else:
            db = db.rename(columns=mapping)

        db = __prepare__(db, set_pais=False, set_apelido=False)

        joined = pd.merge(df, db, on='País (canonical)', how='left', suffixes=('', '_db'))

        joined.loc[:, 'id_pais'] = joined.loc[:, 'id_pais_db']
        joined.loc[:, 'id_apelido_pais'] = joined.loc[:, 'id_apelido_pais_db']

        joined = joined[original_columns + ['id_pais', 'id_apelido_pais']]
        joined = joined.drop_duplicates(subset=['Ano', 'Universidade', 'id_pais'], keep='first')

        return joined

    def get_context_data(self, **kwargs):
        super().get_context_data(**kwargs)

        df = kwargs['df']
        request = kwargs['request']
        id_ranking = kwargs['id_ranking']

        df.reset_index(inplace=True)
        # o índice não quer dizer muita coisa nesse contexto, mas é necessário um número
        rows = df.loc[df['id_pais'].isna(), ['index', 'id_pais', 'País']].drop_duplicates(subset=['País'])

        return {
            'id_ranking': id_ranking,
            'rows': rows.to_dict(orient='records'),
            'country_options': [{'id_pais': '', 'nome_portugues': ''}] + [
                {'id_pais': x.id_pais, 'nome_portugues': x.nome_portugues}
                for x in Pais.objects.all()
            ],
            'country_type_options': [{'id_tipo_apelido': '', 'tipo_apelido': ''}] + pd.DataFrame(
                TipoApelido.objects.values('id_tipo_apelido', 'tipo_apelido')
            ).to_dict(orient='records')
        }

    @staticmethod
    def correlate_missing_countries(form, df):
        """
        Dado um formulário preenchido pelo usuário, correlaciona os países faltantes no DataFrame com os países do banco
        de dados.

        :param form: Formulário de requisição POST.
        :param df: O DataFrame preenchido até então.
        :return:  O DataFrame, com o id_pais definido para todas as linhas.
        """
        _dict = form.dict()
        keys = list(_dict.keys())

        lines = [re.findall('select-country-([0-9]+)', x) for x in keys]
        lines = [int(x[0]) for x in lines if len(x) > 0]

        data = {
            i: {
                'País': form[f'country-name-{i}'],
                'id_pais': int(form[f'select-country-{i}']),
                'type': int(form[f'select-type-{i}'])
            } for i in lines
        }

        for i, data in data.items():
            apelido = ApelidoDePais(tipo_apelido_id=data['type'], apelido=data['País'], pais_id=data['id_pais'])
            apelido.save()

            # _index = df['País'] == data['País']
            #
            # df.loc[_index, 'id_pais'] = data['id_pais']
            # df.loc[_index, 'id_apelido_pais'] = apelido.id_apelido

        update_ultima_carga(
            'R_PAISES_APELIDOS',
            'Nomes alternativos para países nos rankings acadêmicos (e.g. \'Hong Kong\' -> \'China\')'
        )

        return df


    def get(self, request, *args, **kwargs):
        ranking, df = get_dataframe_from_session(request)
        df = MissingCountriesPreview.insert_id_pais(df)

        # se algum registro não tem id de país setado
        if df['id_pais'].isna().sum() > 0:
            return render(
                request,
                'rankings/countries/missing/preview.html',
                context=self.get_context_data(df=df, request=request, id_ranking=ranking.id_ranking)
            )

        request.session['df'] = df.to_json()
        request.session['id_ranking'] = ranking.id_ranking

        return redirect(reverse('ranking-insert-success'))

    def post(self, request, *args, **kwargs):
        ranking, df = get_dataframe_from_session(request)

        df = MissingCountriesPreview.correlate_missing_countries(request.POST, df)
        df = MissingCountriesPreview.insert_id_pais(df)

        request.session['df'] = df.to_json()
        request.session['id_ranking'] = ranking.id_ranking

        return redirect(reverse("ranking-insert-success"))


class RankingInsertView(TemplateView):
    template_name = 'rankings/ranking/insert/index.html'

    def get(self, request, *args, **kwargs):
        form = InsertRankingForm()
        return render(request, self.template_name, {'form': form})

    def post(self, request, *args, **kwargs):
        form = InsertRankingForm(request.POST, request.FILES)
        if not form.is_valid():
            return render(
                request,
                'rankings/ranking/insert/index.html',
                {'form': form}
            )

        df = form.cleaned_data['dataframe']
        ranking = form.cleaned_data['ranking']
        try:
            request.session['df'] = df.to_json()
            request.session['id_ranking'] = ranking.id_ranking

            return redirect(reverse('missing-countries-preview'))

        except ValidationError as e:
            messages.error(request, e.message)
            return render(
                request,
                'rankings/ranking/insert/index.html',
                {'form': form, 'error_message': e.message}
            )
