import re

from django.contrib import messages
from django.core.exceptions import ValidationError, PermissionDenied
from django.db.models import Count
from django.shortcuts import render
from django.views.generic import TemplateView

from .forms import InsertRankingForm
from .models import PilarValor, Pilar
from .models import Universidade, ApelidoDePais
from .scripts import (
    save_ranking_file, load_ranking_file, insert_id_university,
    insert_ranking_data, \
    remove_forms, __missing_countries_preview__
)


class IndexView(TemplateView):
    template_name = 'rankings/index.html'

    def get(self, request, *args, **kwargs):
        n_universidades = Universidade.objects.count()
        unis_by_pais_apelido = Universidade.objects.all().values('pais_apelido').annotate(total=Count('pais_apelido'))
        count_values_by_pillar = PilarValor.objects.all().values('pilar_id').annotate(total=Count('pilar_id'))
        ranking_ids = set()

        set_countries = set()
        for x in unis_by_pais_apelido:
            set_countries = set_countries.union(
                {ApelidoDePais.objects.filter(id_apelido=x['pais_apelido']).first().pais})

        for x in count_values_by_pillar:
            id_pilar = x['pilar_id']
            ranking_ids = ranking_ids.union({Pilar.objects.filter(id_pilar=id_pilar).first().ranking_id})

        n_pillars = len(count_values_by_pillar)

        context = {
            'display_greetings': True,
            'information_list': [
                {'name': 'universidade' + ('s' if n_universidades != 1 else ''), 'value': n_universidades},
                {'name': 'país' + ('es' if len(set_countries) != 1 else ''), 'value': len(set_countries)},
                {'name': 'ranking' + ('s' if len(ranking_ids) != 1 else ''), 'value': len(ranking_ids)},
                {'name': 'pilar' + ('es' if n_pillars != 1 else ''), 'value': n_pillars}
            ]
        }
        return render(request, 'rankings/index.html', context)


def success_insert_ranking(request):
    if request.method == 'POST':
        return render(request, 'rankings/ranking/insert/success.html')
    raise PermissionDenied()


class MissingCountriesPreview(TemplateView):
    def get(self, request, *args, **kwargs):
        raise PermissionDenied()

    def post(self, request, *args, **kwargs):
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


class RankingInsertView(TemplateView):
    template_name = 'rankings/ranking/insert/index.html'

    def get(self, request, *args, **kwargs):
        form = InsertRankingForm()
        remove_forms()
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
            df, id_formulario = save_ranking_file(df, ranking)
            request, df, ranking, id_formulario = __missing_countries_preview__(
                request, df, id_formulario=id_formulario, id_ranking=ranking
            )
            df = insert_id_university(df)
            df, id_formulario = save_ranking_file(df, id_ranking=ranking, id_formulario=id_formulario)
            insert_ranking_data(df, id_ranking=ranking, id_formulario=id_formulario)
            return success_insert_ranking(request)

        except ValidationError as e:
            messages.error(request, e.message)
            return render(
                request,
                'rankings/ranking/insert/index.html',
                {'form': form, 'error_message': e.message}
            )
