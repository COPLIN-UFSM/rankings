from datetime import datetime as dt

from django import forms
from django.core.exceptions import ValidationError
from django.core.files.uploadedfile import InMemoryUploadedFile

from .models import Ranking


def check_year(year):
    current_year = dt.now().year
    if year < 1900:
        raise ValidationError(f'O menor ano de ranking possível é 1900!')
    if year > (current_year + 2):
        raise ValidationError(
            f'O ano inserido está {year - current_year} anos no futuro! Tem certeza que você digitou certo?'
        )


def check_dataframe(file: InMemoryUploadedFile):
    ext = file.name.split('.')[-1].lower()
    if ext != 'csv':
        raise ValidationError('A planilha deve ser do tipo csv!')

    # try:
    #     df = get_dataframe(file)
    # except:
    #     raise ValidationError(
    #         'Não foi possível abrir a planilha. Verifique se a mesma possui aspas '
    #         'para delimitar texto e usa vírgula como separador de colunas')


class InsertRankingForm(forms.Form):
    ranking = forms.CharField(
        label='Nome do Ranking',
        widget=forms.Select(choices=[(x.id_ranking, x.nome) for x in Ranking.objects.all()])
    )
    file = forms.FileField(label='Planilha (tipo csv)', validators=[check_dataframe])


class RemoveReplicatePillarsForm(forms.Form):
    pass
    # ranking = forms.CharField(
    #     label='Nome do Ranking',
    #     widget=forms.Select(choices=[(x.id_ranking, x.nome) for x in Ranking.objects.all()])
    # )
    # file = forms.FileField(label='Planilha (tipo csv)', validators=[check_dataframe])
