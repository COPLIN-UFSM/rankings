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
conda env create -f environment.yml
```

## Execução da aplicação

### Primeira execução

Siga uma das duas opções abaixo, dependendo do seu caso de uso.

<details>
<summary><h4>Não tenho acesso ao banco bee da UFSM</h4></summary>

1. Será necessário trocar as configurações no [settings.py](app/app/settings.py) para usar um banco de dados local:

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

2. Rode o script [ibmdb_create.sql](app/database_scripts/ibmdb_create.sql) para criar as tabelas no banco de dados;
3. Execute os seguintes comandos:

   ```bash
   conda activate rankings
   python manage.py makemigrations rankings
   python manage.py migrate
   ```

</details>

<details>
<summary><h4>Tenho acesso ao banco bee</h4></summary>

<details>
<summary><h5>Quero recriar o banco de dados</h5></summary>

> [!CAUTION]
> Esta ação irá deletar **todas** as tabelas do banco de dados, referentes aos rankings. Pense bem se é exatamente isso
> que você quer fazer!

1. Rode o script [ibmdb_drop.sql](app/database_scripts/ibmdb_drop.sql) para deletar **todas** as tabelas do banco de dados de rankings;
2. Rode o script [ibmdb_create.sql](app/database_scripts/ibmdb_create.sql) para recriar as tabelas do zero;
3. Execute os seguintes comandos:

   ```bash
   conda activate rankings
   python manage.py makemigrations rankings
   python manage.py migrate
   ```

> [!NOTE]
> Pode ser que ao executar o comando `python manage.py migrate` com o banco de dados IBM DB2, um erro ocorra 
> na migração. Simplesmente ignore este erro.

</details>

<details>
<summary><h5>Quero refletir alterações feitas na estrutura das tabelas do banco de dados</h5></summary>

1. Execute os seguintes comandos:

   ```bash
   conda activate rankings
   python manage.py makemigrations rankings
   python manage.py migrate
   ```

> [!NOTE]
> Pode ser que ao executar o comando `python manage.py migrate` com o banco de dados IBM DB2, um erro ocorra 
> na migração. Simplesmente ignore este erro.

</details>

</details>

### Execuções subsequentes

1. Entre na pasta `app`
2. Execute os seguintes comandos:

   ```bash
   conda activate rankings
   python manage.py runserver
   ```

3. Acesse o site pelo link disponibilizado pelo console: http://localhost:8000/ranking/insert

## Diagrama do banco de dados

É possível consultar o diagrama do banco de dados no arquivo [SCHEMA](app/database_scripts/SCHEMA.md).

## Contato

Repositório originalmente desenvolvido por Henry Cagnini: [henry.cagnini@ufsm.br]()

## Bibliografia

* [Documentação ibm_db](https://www.ibm.com/docs/en/db2/11.5?topic=framework-application-development-db)

