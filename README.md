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

### Produção

#### Configuração

```bash
python manage.py makemigrations rankings 
python manage.py migrate --database=local_sqlite
python manage.py soft_reset
```

#### Subsequentes

Para executar a aplicação:

```bash
   python manage.py runserver
   ```

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

