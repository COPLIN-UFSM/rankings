import importlib
import sys
import os

import pandas as pd
import django
from tqdm import tqdm


def main(read_path):
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.app.settings')

    # --- patch start ---
    project_root = os.path.dirname(os.path.dirname(__file__))
    real_router_path = os.path.join(project_root, 'app', 'db_routers.py')
    if os.path.exists(real_router_path):
        spec = importlib.util.spec_from_file_location('app.db_routers', real_router_path)
        module = importlib.util.module_from_spec(spec)
        sys.modules['app.db_routers'] = module
        spec.loader.exec_module(module)
    # --- patch end ---

    django.setup()

    from rankings.models import Universidade, ApelidoDeUniversidade, ApelidoDePais
    brasil = ApelidoDePais.objects.get(apelido__iexact='Brasil')
    id_apelido_pais = brasil.pk

    df = pd.read_csv(read_path)
    df = df.loc[df['País'] == 'Brasil']

    gb = df.groupby(by=['COD_IES'], as_index=False)

    for cod_ies, index in tqdm(
        gb.groups.items(),
        total=len(gb.groups.items()),
        desc='Inserindo universidades brasileiras no banco de dados'
    ):
        rows = gb.get_group(cod_ies)

        universidade = Universidade(
            nome_portugues=rows.iloc[0]['Universidade'],
            nome_ingles=rows.iloc[0]['Universidade'],
            cod_ies=cod_ies,
            pais_apelido_id=id_apelido_pais
        )
        universidade.save()

        for i, row in rows.iterrows():
            apelido = ApelidoDeUniversidade(
                universidade=universidade,
                apelido=row['Universidade']
            )
            apelido.save()

if __name__ == '__main__':
    _path = os.path.join(os.path.dirname(__file__), '..', 'rankings', 'tests', 'data', 'test_ies.csv')
    if not os.path.exists(_path):
        raise FileNotFoundError(
            'Esse script precisa de um arquivo de csv com as IES brasileiras (da tabela IES do banco bee) em '
            'tests/data/test_ies.csv'
        )
    main(_path)
