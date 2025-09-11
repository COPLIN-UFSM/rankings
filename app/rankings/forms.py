import re
from io import StringIO

import numpy as np
import pandas as pd
from django import forms
from django.core.exceptions import ValidationError
from django.core.files.uploadedfile import InMemoryUploadedFile

from .models import Ranking
from .scripts import get_document_pillars


def check_dataframe_consistency(file: InMemoryUploadedFile):
    ext = file.name.split('.')[-1].lower()
    if ext != 'csv':
        raise ValidationError('O arquivo deve ser do tipo csv!')


class InsertRankingForm(forms.Form):
    ranking = forms.ModelChoiceField(
        label='Nome do Ranking',
        queryset=Ranking.objects.order_by('nome'),
        widget=forms.Select
    )
    file = forms.FileField(label='Planilha (tipo csv)', validators=[check_dataframe_consistency])

    @staticmethod
    def check_ranking_file_consistency(df: pd.DataFrame, ranking: Ranking) -> pd.DataFrame:
        """
        Verifica se a planilha de um ranking que está sendo inserido possui todos os pilares do ranking.
        Se houver alguma inconsistência, levanta uma exceção do tipo ValidationError com a mensagem do erro.

        :param df: DataFrame que está sendo inserido no site
        :param ranking: o ranking na tabela Rankings
        """
        # verifica colunas básicas
        if 'Universidade' not in df.columns:
            raise ValidationError(f'A planilha deve conter uma coluna de nome \'Universidade\'!')
        if 'País' not in df.columns:
            raise ValidationError(f'A planilha deve conter uma coluna de nome \'País\'!')
        if 'Ano' not in df.columns:
            raise ValidationError(f'A planilha deve conter uma coluna de nome \'Ano\'!')

        def __convert_column_values_to_list__(_x) -> list:
            if pd.isna(_x):
                return [None, None]
            if isinstance(_x, float) or isinstance(_x, int):
                return [float(_x), None]

            _x = re.findall('([0-9\.]+)', _x)

            # for rep in string.punctuation + '—–':
            #     _x = _x.replace(rep, ' ')
            # _x = _x.split()
            return ([float(y) for y in _x] + [None, None])[:2]

        # verifica se o ranking existe no banco de dados
        if ranking is None:
            raise ValidationError(f'O ranking informado não foi encontrado na base de dados! Se este for um novo '
                                  f'ranking, você terá que adicioná-lo manualmente na tela de administrador.')

        # verifica se todos os pilares estão no documento
        pillars = get_document_pillars(df, ranking=ranking)

        # reporter é colocado pelo THE ranking para universidades que estão relacionadas mas não possuem uma ordem
        df = df.replace({None: np.nan, '-': np.nan, 'Reporter': np.nan, 'reporter': np.nan,
                         'n/a': np.nan, 'NA': np.nan, 'na': np.nan})

        column_renaming = {}
        for pillar in pillars:
            try:
                new_name = pillar['Pilar'] + '_as_list'
                column_renaming[new_name] = pillar['Pilar']

                df.loc[:, new_name] = df[pillar['Pilar']].apply(__convert_column_values_to_list__)
            except Exception as e:
                raise ValidationError(
                    'Para cada coluna de pilar, os números devem ter a casa decimal como ponto (e.g. 10.9), e serem '
                    'separados por travessão (-), caso possuam mais de um valor.'
                )

        df = df.drop(columns=column_renaming.values())
        df = df.rename(columns=column_renaming)

        column_renaming = {}

        df = df.drop(columns=column_renaming.values())
        df = df.rename(columns=column_renaming)

        return df

    @staticmethod
    def to_dataframe(file: InMemoryUploadedFile):
        """
        Transforma um arquivo CSV em um pandas.DataFrame.
        """
        some_file = file.read().decode('utf-8')
        df = pd.read_csv(StringIO(some_file), encoding='utf-8')
        return df

    def clean_file(self):
        file = self.cleaned_data['file']
        df = InsertRankingForm.to_dataframe(file.file)
        ranking = self.cleaned_data['ranking']

        df = InsertRankingForm.check_ranking_file_consistency(df, ranking)
        self.cleaned_data['dataframe'] = df
        return file

    def clean(self):
        pass