# Rankings

Uma aplicação Web para gerenciamento de Rankings Acadêmicos.

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
conda install --file requirements.txt --yes
pip install --requirement pip_requirements.txt
```

## Execução da aplicação

### Primeira execução

1. Entre na pasta `app`
2. Execute os seguintes comandos:

   ```bash
   conda activate rankings
   python manage.py makemigrations rankings
   python manage.py migrate 
   python manage.py runserver
   ```

### Execuções subsequentes

1. Entre na pasta `app`
2. Execute os seguintes comandos:

   ```bash
   conda activate rankings
   python manage.py runserver
   ```

## Contato

Repositório originalmente desenvolvido por Henry Cagnini: [henry.cagnini@ufsm.br]()

## Bibliografia

* [Documentação ibm_db](https://www.ibm.com/docs/en/db2/11.5?topic=framework-application-development-db)

