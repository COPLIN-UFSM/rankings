# Rankings

Uma aplicação Web para gerenciamento de Rankings Acadêmicos, criada pela Coordenadoria de Planejamento Informacional 
da UFSM - COPLIN/PROPLAN.

## Pré-requisitos

Este repositório requer a última versão do [Python Anaconda](https://www.anaconda.com/download) para ser executado, 
visto que usa o gerenciador de pacotes conda. O código executará em qualquer Sistema Operacional, mas foi desenvolvido
originalmente para Windows 10 Pro (64 bits).

As configurações da máquina que o repositório foi desenvolvido encontram-se na tabela abaixo:

| Configuração        | Valor                    |
|---------------------|--------------------------|
| Sistema operacional | Windows 10 Pro (64 bits) |
| Processador         | Intel core i7 9700       |
| Memória RAM         | 16GB                     |
| Necessita rede?     | Sim                      |

## Instalação

```bash
conda create --name rankings python==3.11.* pip --yes
conda activate rankings
pip install ibm_db
pip install "git+https://github.com/COPLIN-UFSM/db2.git"
conda install --file requirements.txt --yes
pip install --requirement pip_requirements.txt
```

## Execução da aplicação

### Primeira execução

**IMPORTANTE:** caso você não tenha acesso ao banco de dados bee da UFSM, mude no arquivo `settings.py` para usar o
banco de dados local:

```python
DATABASES = {
    # para usar o banco de dados local, use esta opção
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'database_sqlite.db',
    },
    # para usar o banco de dados remoto, use esta opção
    # 'default': {
    #     "NAME": 'BEE',
    #     "ENGINE": 'ibm_db_django',
    #     "DATABASE": get_secret('database'),
    #     "HOST": get_secret('host'),
    #     "PORT": get_secret('port'),
    #     "USER": get_secret('user'),
    #     "PASSWORD": get_secret('password'),
    #     "OPTIONS": {
    #         'dsn': f"DATABASE={get_secret('database')};HOSTNAME={get_secret('host')};"
    #                f"PORT={get_secret('port')};PROTOCOL=TCPIP;"
    #     },
    #     'PCONNECT': True,  
    # },
}
```

Só é necessário executar este passo-a-passo na **primeira** vez que o banco de dados for criado. Depois disso, 
é desnecessário.

1. Entre na pasta `app`
2. Rode o script `ibmdb_drop.sql` para deletar **todas** as tabelas do banco de dados de rankings;
3. Rode o script `ibmdb_create.sql` para recriar as tabelas do zero;
4. Execute os seguintes comandos:

   ```bash
   conda activate rankings
   python manage.py makemigrations rankings
   python manage.py migrate
   ```

**NOTA:** pode ser que ao executar o comando `python manage.py migrate` com o banco de dados IBM DB2, um erro ocorra
na migração. Simplesmente ignore este erro.

### Execuções subsequentes

1. Entre na pasta `app`
2. Execute os seguintes comandos:

   ```bash
   conda activate rankings
   python manage.py runserver
   ```

## Diagrama do banco de dados

É possível consultar o diagrama do banco de dados no arquivo [SCHEMA](app/database_scripts/SCHEMA.md).

## Contato

Repositório originalmente desenvolvido por Henry Cagnini: [henry.cagnini@ufsm.br]()

## Bibliografia

* [Documentação ibm_db](https://www.ibm.com/docs/en/db2/11.5?topic=framework-application-development-db)

