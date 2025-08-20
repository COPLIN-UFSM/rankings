import re

import pandas as pd
from django.contrib import messages
from django.core.exceptions import ValidationError, PermissionDenied
from django.db.models import Count
from django.shortcuts import render
from django.template.loader import render_to_string, get_template
from django.views.generic import TemplateView
from tqdm import tqdm

from .forms import InsertRankingForm
from .models import MetricaValor, PilarValor, Pilar, PilaresParaGrupos, MetricasParaPilares
from .models import Pais, Universidade, TipoApelido, ApelidoDePais, ApelidoDeUniversidade
from .scripts import get_dataframe, save_ranking_file, load_ranking_file, insert_id_university, \
    check_ranking_file_consistency, insert_id_country, __get_all_universities__, insert_ranking_data, \
    get_canonical_name, __remove_forms__
from .scripts.universities import remove_unused_universities_and_nicknames, \
    merge_replicate_universities


def index(request):
    n_universidades = Universidade.objects.count()
    unis_by_pais_apelido = Universidade.objects.all().values('pais_apelido').annotate(total=Count('pais_apelido'))
    count_values_by_pillar = PilarValor.objects.all().values('pilar_id').annotate(total=Count('pilar_id'))
    count_values_by_metric = MetricaValor.objects.all().values('metrica_id').annotate(total=Count('metrica_id'))
    ranking_ids = set()

    set_countries = set()
    for x in unis_by_pais_apelido:
        set_countries = set_countries.union({ApelidoDePais.objects.filter(id_apelido=x['pais_apelido']).first().pais})

    for x in count_values_by_pillar:
        id_pilar = x['pilar_id']
        ranking_ids = ranking_ids.union({Pilar.objects.filter(id_pilar=id_pilar).first().ranking_id})

    n_pillars = len(count_values_by_pillar)
    n_metrics = len(count_values_by_metric)

    context = {
        'display_greetings': True,
        'information_list': [
            {'name': 'universidade' + ('s' if n_universidades != 1 else ''), 'value': n_universidades},
            {'name': 'país' + ('es' if len(set_countries) != 1 else ''), 'value': len(set_countries)},
            {'name': 'ranking' + ('s' if len(ranking_ids) != 1 else ''), 'value': len(ranking_ids)},
            {'name': 'pilar' + ('es' if n_pillars != 1 else ''), 'value': n_pillars},
            {'name': 'métrica' + ('s' if n_metrics != 1 else ''), 'value': n_metrics}
        ]
    }
    return render(request, 'rankings/index.html', context)


def success_insert_ranking(request):
    if request.method == 'POST':
        return render(request, 'rankings/ranking/insert/success.html')
    raise PermissionDenied()


def success_remove_duplicate_universities(request):
    if request.method == 'POST':
        return render(request, 'rankings/universities/duplicate/success.html')
    raise PermissionDenied()


def merger_universities_preview(request):
    # countries_list = Pais.objects.order_by('nome_portugues').values('id_pais', 'nome_portugues')
    unis = __get_all_universities__()
    groups = unis.groupby(by=['id_pais', 'País']).groups
    countries_list = [{'id_pais': f'{c[0]}', 'nome_pais_portugues': f'{c[1]}'} for c in groups.keys()]
    universities_per_country = []
    for keys, indices in groups.items():
        universities_per_country += [
            {
                'id_pais': keys[0],
                'universities': unis.loc[
                     indices, ['id_apelido_universidade', 'Universidade']
                ].to_dict(orient='records')
             }
        ]

    return render(
        request,
        'rankings/universities/merger/preview.html',
        context={
            'countries_list': countries_list,
            'universities_per_country': universities_per_country
        }
    )


def merger_universities_insert(request):
    if request.method == 'POST':
        form = request.POST

        _dict = form.dict()
        keys = list(_dict.keys())

        data = [re.findall('input-datalist-([0-9]+)', x) for x in keys]
        data = {
            int(x[0]):
                {
                    'name': _dict[f'input-datalist-{x[0]}'],
                    'use_portuguese': _dict[f'flexRadioPT-{x[0]}'] == 'on' if f'flexRadioPT-{x[0]}' in _dict else False,
                    'use_english': _dict[f'flexRadioEN-{x[0]}'] == 'on' if f'flexRadioEN-{x[0]}' in _dict else False,
                }
            for x in data if len(x) > 0
        }

        subset = pd.DataFrame(data).T

        # remove_unused_universities_and_nicknames()
        merge_replicate_universities(subset)  # TODO implement!

        return success_remove_duplicate_universities(request)

    raise PermissionDenied()


def duplicate_universities_preview(request):
    universities = __get_all_universities__()
    universities = universities.drop_duplicates(subset=['id_universidade', 'id_pais'], keep='first')

    universities['Universidade (canonical)'] = universities['Universidade'].apply(lambda x: hash(get_canonical_name(x)))

    double_index = universities.duplicated(subset=['Universidade (canonical)', 'id_pais'], keep=False)

    if double_index.sum() == 0:
        return render(request, 'rankings/universities/duplicate/not_found.html')

    subset = universities.loc[double_index]
    subset = subset.sort_values(by='Universidade (canonical)')
    subset['assigned'] = ''

    canonical_names = subset['Universidade (canonical)'].unique()

    for i, name in enumerate(canonical_names):
        subset.loc[subset['Universidade (canonical)'] == name, 'assigned'] = f'{i + 1}'

    universities_list = subset[
        ['id_universidade', 'id_apelido_universidade', 'Universidade', 'País', 'assigned']
    ].reset_index().to_dict(orient='records')

    return render(
        request,
        'rankings/universities/duplicate/preview.html',
        context={
            'universities_list': universities_list,
            'options': [{'value': '', 'text': ''}, {'value': 'NA', 'text': 'NA'}] +
                       [{'value': f'{n}', 'text': f'{n}'} for n in range(1, len(universities_list) + 1)]
        }
    )


def duplicate_universities_insert(request):
    if request.method == 'POST':
        form = request.POST

        _dict = form.dict()
        keys = list(_dict.keys())

        lines = [re.findall('university-id-([0-9]+)', x) for x in keys]
        lines = [int(x[0]) for x in lines if len(x) > 0]

        data = [
            {
                'id_apelido_universidade': form[f'university-nickname-id-{i}'],
                'id_universidade': form[f'university-id-{i}'],
                'assigned': form[f'select-assigned-{i}']
            } for i in lines
        ]
        subset = pd.DataFrame(data)
        subset = subset.loc[subset['assigned'] != 'NA']  # remove as não-duplicadas

        values = subset['assigned'].unique()

        for val in values:  # para cada conjunto de universidades que são as mesmas
            uni_ids = subset.loc[subset['assigned'] == val, ['id_apelido_universidade', 'id_universidade']]
            parent_id = uni_ids.iloc[0]  # o primeiro registro vira o pai
            children_id = uni_ids.iloc[1:]  # os outros receberão o id_universidade do pai

            parent = ApelidoDeUniversidade.objects.get(
                id_apelido=parent_id['id_apelido_universidade']
            )
            children = ApelidoDeUniversidade.objects.filter(
                id_apelido__in=children_id['id_apelido_universidade']
            )
            parent_uni = Universidade.objects.get(id_universidade=parent.universidade.id_universidade)

            for child in children:
                child.universidade = parent_uni
                child.save(update_fields=['universidade'])

        # remove_unused_universities_and_nicknames()

        return success_remove_duplicate_universities(request)

    raise PermissionDenied()


def missing_countries_insert(request):
    if request.method == 'POST':
        form = request.POST
        id_formulario = form['id_formulario']
        id_ranking = form['id_ranking']

        _dict = form.dict()
        keys = list(_dict.keys())
        df = load_ranking_file(id_formulario)

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

            _index = df['País'] == data['País']

            df.loc[_index, 'id_pais'] = data['id_pais']
            df.loc[_index, 'id_apelido_pais'] = apelido.id_apelido

        return __insert_id_university_step__(request, df, id_ranking=id_ranking, id_formulario=id_formulario)
    raise PermissionDenied()


def __insert_id_university_step__(request, df, id_ranking, id_formulario):
    df = insert_id_university(df)
    df, id_formulario = save_ranking_file(df, id_ranking=id_ranking, id_formulario=id_formulario)
    insert_ranking_data(df, id_ranking=id_ranking, id_formulario=id_formulario)
    return success_insert_ranking(request)


def __missing_countries_preview__(request, df, id_formulario, id_ranking):
    df = insert_id_country(df)
    df, id_formulario = save_ranking_file(df, id_ranking=id_ranking, id_formulario=id_formulario)

    # se algum registro não tem id de país setado
    if df['id_pais'].isna().sum() > 0:
        df.reset_index(inplace=True)
        # o índice não quer dizer muita coisa nesse contexto, mas é necessário um número
        rows = df.loc[df['id_pais'].isna(), ['index', 'id_pais', 'País']].drop_duplicates(subset=['País'])
        return render(
            request,
            'rankings/countries/missing/preview.html',
            context={
                'id_formulario': id_formulario,
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
        )

    return __insert_id_university_step__(request, df, id_ranking=id_ranking, id_formulario=id_formulario)


class RankingInsertView(TemplateView):
    template_name = 'rankings/ranking/insert/index.html'

    def get(self, request, *args, **kwargs):
        form = InsertRankingForm()
        __remove_forms__()
        return render(request, self.template_name, {'form': form})

    def post(self, request, *args, **kwargs):
        form = InsertRankingForm(request.POST, request.FILES)
        if form.is_valid():
            df = get_dataframe(request.FILES['file'])
            id_ranking = form.cleaned_data['ranking']
            try:
                df = check_ranking_file_consistency(df, id_ranking)
                df, id_formulario = save_ranking_file(df, id_ranking)
                return __missing_countries_preview__(request, df, id_formulario=id_formulario, id_ranking=id_ranking)
            except ValidationError as e:
                messages.error(request, e.message)
                return render(
                    request,
                    'rankings/ranking/insert/index.html',
                    {'form': form, 'error_message': e.message}
                )


class MergerPillarsPreview(TemplateView):
    template_name = 'rankings/pillars/merger/preview.html'

    # def get(self, request, *args, **kwargs):
    #     raise PermissionDenied()

    def post(self, request, *args, **kwargs):
        form = request.POST

        _dict = form.dict()

        id_ranking = int(_dict['input-ranking-id'])

        index = 0
        to_use = None  # pilar a ser usado como principal
        to_replace_names = []  # pilares a serem substituídos pelo principal
        while f'input-datalist-{index}' in _dict:
            nome_pilar = _dict[f'input-datalist-{index}']

            if f'flexRadioMain-{index}' in _dict:
                to_use = nome_pilar
            else:
                to_replace_names += [nome_pilar]

            index += 1

        if len(to_replace_names) == 0 or to_use is None:
            context = self.get_context_data()
            context['error_message'] = 'Erro: pelo menos dois pilares devem ser selecionados!'
            return render(request, self.template_name, context)

        to_replace = Pilar.objects.filter(nome_ingles__in=to_replace_names, ranking_id=id_ranking)
        to_use = Pilar.objects.filter(nome_ingles=to_use, ranking_id=id_ranking)[0]

        to_replace_ids = [x.id_pilar for x in to_replace]

        # atualiza todas as tabelas
        # atualiza pilar valor
        qs = PilarValor.objects.filter(pilar__id_pilar__in=to_replace_ids)
        with tqdm(range(len(qs)), desc='Atualizando ID_PILAR na tabela R_PILARES_VALORES') as pbar:
            for q in qs:
                valor_inicial = q.valor_inicial
                valor_final = q.valor_final
                apelido_universidade_id = q.apelido_universidade_id
                ano = q.ano

                nq = PilarValor.objects.create(
                    pilar=to_use, apelido_universidade_id=apelido_universidade_id, ano=ano,
                    valor_inicial=valor_inicial, valor_final=valor_final
                )

                q.delete()  # deleta instância antiga no banco
                nq.save()  # salva nova instância no banco

                pbar.update(1)

        # atualiza pilares para grupos
        qs = PilaresParaGrupos.objects.filter(pilar__id_pilar__in=to_replace_ids)
        for q in qs:
            grupo_pilares_id = q.grupo_pilares_id

            nq = PilaresParaGrupos.objects.create(pilar=to_use, grupo_pilares_id=grupo_pilares_id)

            q.delete()  # deleta instância antiga no banco
            nq.save()  # salva nova instância no banco

        # atualiza métricas para pilares
        qs = MetricasParaPilares.objects.filter(pilar__id_pilar__in=to_replace_ids)
        for q in qs:
            metrica_id = q.metrica_id
            peso = q.peso

            nq = MetricasParaPilares.objects.create(pilar=to_use, metrica_id=metrica_id, peso=peso)

            q.delete()  # deleta instância antiga no banco
            nq.save()  # salva nova instância no banco

        # deleta pilares antigos
        for p in to_replace:
            p.delete()

        return render(request, 'rankings/pillars/merger/success.html')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        pillars = pd.DataFrame([
            {
                'id_ranking': x.ranking.id_ranking, 'nome_ranking': x.ranking.nome,
                'id_pilar': x.id_pilar, 'nome_pilar': x.nome_ingles
            }
            for x in Pilar.objects.all()
        ])
        pillars = pillars.sort_values(by='nome_pilar')

        groups = pillars.groupby(by=['id_ranking', 'nome_ranking']).groups
        rankings_list = [{'id_ranking': f'{c[0]}', 'nome_ranking': f'{c[1]}'} for c in groups.keys()]
        pillars_per_ranking = []
        for keys, indices in groups.items():
            pillars_per_ranking += [
                {
                    'id_ranking': keys[0],
                    'pillars': pillars.loc[
                        indices, ['id_pilar', 'nome_pilar']
                    ].to_dict(orient='records')
                }
            ]

        context['rankings_list'] = rankings_list
        context['pillars_per_ranking'] = pillars_per_ranking

        input_group_code = get_template('rankings/pillars/merger/input_group.html').template.source
        input_group_code = input_group_code.replace('\n', '\\n')

        context['input_group_code'] = input_group_code

        return context
