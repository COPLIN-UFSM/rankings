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

### Desenvolvimento

A aplicação de desenvolvimento usa apenas um banco de dados SQLite, tanto para tabelas do Django quanto para tabelas
de dados da aplicação. Este banco é totalmente independente do banco de produção (banco bee).

#### Configuração

1. Delete os arquivos de migração em [migrations](app/rankings/migrations)
2. Execute os seguintes comandos (a partir da pasta [app](app)):
   ```bash
   python manage.py makemigrations --settings=app.dev_settings
   python manage.py migrate --settings=app.dev_settings
   python manage.py hard_reset --settings=app.dev_settings
   ```

#### Subsequentes

Para executar a aplicação:

```bash
python manage.py runserver --settings=app.dev_settings
```

Acesse o servidor em `http://localhost:8000/ranking`

### Produção

A aplicação de produção usa dois bancos de dados, um SQLite para tabelas do Django, e o banco bee (IBM DB2) para as 
tabelas da aplicação. 

#### Configuração

A configuração precisa ser feita uma vez **por máquina** que vá acessar a aplicação. Isto acontece pois, como esta 
aplicação usa um banco de dados SQLite local para armazenar dados do Django, ele precisa ser configurado a cada nova
máquina que roda a aplicação.

1. Delete os arquivos de migração em [migrations](app/rankings/migrations)
2. Execute os seguintes comandos (a partir da pasta [app](app)):
   ```bash
   python manage.py makemigrations rankings 
   python manage.py migrate --database=local_sqlite
   ```
3. **⚠️ ATENÇÃO: ⚠️** caso você queira remover alguns dados do banco da aplicação (banco bee), execute o comando 
   abaixo:
   ```bash
   python manage.py soft_reset
   ```
   Execute `python manage.py soft_reset --help` para listar quais tabelas serão afetadas por esse comando.

#### Subsequentes

Para executar a aplicação:

```bash
python manage.py runserver
```

Acesse o servidor em `http://localhost:8000/ranking`

## Executando testes

> [!CAUTION]
> Não use o banco de produção para executar os testes! As tabelas de produção podem ser removidas pelo código Django!

Os testes automatizados usando um banco de dados SQLite (ao invés do IBM DB2) para executar testes. As configurações
desse banco de dados estão no arquivo [test_settings.py](app/app/test_settings.py) (enquanto o arquivo usado para
produção é o [settings.py](app/app/settings.py)).

```bash
python manage.py test --settings=app.test_setings 
```

Ou, se estiver executando pelo PyCharm, crie uma configuração como na tela abaixo:

![configuração_testes.png](imagens/configura%C3%A7%C3%A3o_testes.png)

## Contato

* Repositório originalmente desenvolvido por Henry Cagnini: [henry.cagnini@ufsm.br]()
* Contribuições de Douglas Pasqualin: [douglas@ufsm.br]()

## Bibliografia

* [Documentação ibm_db](https://www.ibm.com/docs/en/db2/11.5?topic=framework-application-development-db)

