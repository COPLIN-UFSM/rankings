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

    for i, row in tqdm(gb.iterrows(), total=len(df), desc='Inserindo universidades brasileiras no banco de dados'):
        z = 0

        # universidade = Universidade(
        #     nome_portugues=uni_name,
        #     nome_ingles=uni_name,
        #     cod_ies=cod_ies,
        #     pais_apelido_id=int(row['id_apelido_pais'])
        # )
        # universidade.save()
        #
        # apelido = ApelidoDeUniversidade(
        #     universidade=universidade,
        #     apelido=uni_name
        # )
        # apelido.save()

    # for i, row in df.iterrows():
    #     pass


if __name__ == '__main__':
    _path = os.path.join(os.path.dirname(__file__), '..', 'rankings', 'tests', 'data', 'test_ies.csv')
    if not os.path.exists(_path):
        raise FileNotFoundError(
            'Esse script precisa de um arquivo de csv com as IES brasileiras (da tabela IES do banco bee) em '
            'tests/data/test_ies.csv'
        )
    main(_path)
