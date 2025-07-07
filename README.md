# Projeto Vortex

Uma API PHP de exemplo com mensageria, eventos, testes, OTEL. Objetivo de poder utilizar em dojos.

## ✨ Tecnologias Utilizadas

A tabela abaixo detalha a stack principal do projeto:

| Categoria                  | Tecnologia / Ferramenta  | Versão/Detalhe                      |
| -------------------------- | ------------------------ | ----------------------------------- |
| **Linguagem**              | PHP                      | `8.4`                               |
| **Servidor (Dev)**         | Servidor Embutido do PHP | Apontando para o diretório `public` |
| **Banco de Dados**         | PostgreSQL               | `17+`                               |
| **Mensageria / Eventos**   | NATS com JetStream       | `latest`                            |
| **Tracing Distribuído**    | Jaeger                   | `latest` (via OTLP)                 |
| **Orquestração**           | Docker & Docker Compose  | -                                   |
| **Automação de tarefas**   | GNU Make                 | -                                   |
| **Ferramenta de Migração** | Goose                    | Embutida na imagem da API           |

## 🚀 Primeiros Passos

Siga os passos abaixo para configurar e executar o ambiente de desenvolvimento localmente.

### Pré-requisitos

Antes de começar, garanta que você tenha as seguintes ferramentas instaladas na sua máquina:

-   [Docker](https://www.docker.com/get-started)
-   [Docker Compose](https://docs.docker.com/compose/install/) (geralmente incluído com o Docker Desktop)
-   `make` (geralmente já vem instalado em sistemas Linux e macOS)
-   `git`

### Configuração do Ambiente

O processo de setup é automatizado pelo `Makefile` para simplificar a vida do desenvolvedor.

1.  **Clone o Repositório**

    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd vortex
    ```

2.  **Configure o Ambiente**
    Este é um comando único que prepara todos os arquivos de configuração necessários na raiz do projeto a partir dos templates localizados em `_env/dev/`.

    ```bash
    make setup-dev
    ```

3.  **Construa e Inicie os Containers**
    Este comando irá construir a imagem da API, baixar as outras imagens e iniciar todos os serviços em segundo plano.

    ```bash
    make up
    ```

    _A primeira execução pode demorar alguns minutos, pois o Docker precisa baixar e construir todas as imagens._

Pronto! Seu ambiente de desenvolvimento está no ar.

## 🛠️ Comandos do Dia a Dia

Todos os comandos principais são gerenciados pelo `Makefile`, executados a partir da raiz do projeto.

| Comando                           | Descrição                                                                             |
| --------------------------------- | ------------------------------------------------------------------------------------- |
| `make up`                         | Inicia o ambiente completo em background.                                             |
| `make down`                       | Para e remove todos os containers e a rede do projeto.                                |
| `make logs`                       | Exibe os logs do container da API em tempo real (`Ctrl+C` para sair).                 |
| `make stats`                      | Mostra o uso de recursos (CPU, Memória) dos containers.                               |
| `make shell`                      | Abre um terminal interativo (shell) dentro do container da API.                       |
| `make test`                       | Executa a suíte de testes do PHPUnit.                                                 |
| `make composer install`           | Executa `composer install` dentro do container. Pode ser usado para outros comandos.  |
| `make migrate-up`                 | Aplica todas as migrações de banco de dados pendentes.                                |
| `make migrate-down`               | Reverte a última migração aplicada.                                                   |
| `make migrate-reset`              | Reverte TODAS as migrações (cuidado!).                                                |
| `make migrate-create name=<Nome>` | Cria um novo arquivo de migração. Ex: `make migrate-create name=cria_tabela_usuarios` |

## 🔗 Acessando os Serviços

Com o ambiente no ar, os serviços podem ser acessados nos seguintes endereços:

-   **API Vortex**: [http://localhost:8080](http://localhost:8080)
-   **Jaeger UI (Tracing)**: [http://localhost:16686](http://localhost:16686)
-   **NATS Monitoring**: [http://localhost:8222](http://localhost:8222)

### Conexão com o Banco de Dados (PostgreSQL)

Para se conectar ao banco de dados usando um cliente de sua preferência (DBeaver, DataGrip, etc.), utilize as seguintes credenciais (baseadas no arquivo `.env`):

-   **Host**: `localhost`
-   **Porta**: `5454`
-   **Usuário**: `username`
-   **Senha**: `password`
-   **Banco de Dados**: `vortex-db`

## 📂 Estrutura de Diretórios

```bash
.
├── api
├── captainhook.json
├── composer.json
├── composer.lock
├── db
│   └── migrations
├── docker-compose.yml
├── Dockerfile
├── _docs
├── _env
│   └── dev
│       ├── dev.env
│       ├── docker-compose.yml
│       ├── Dockerfile
│       ├── otel-collector-config.yml
│       └── php.ini
├── LICENSE
├── Makefile
├── phpstan.neon
├── phpunit.xml
├── pint.json
├── public
│   └── index.php
├── README.md
├── src
│   ├── App
│   ├── Contexts
│   │   └── Identity
│   │       ├── App
│   │       ├── Domain
│   │       └── Infra
│   ├── main.php
│   └── Platform
│       ├── Adapter
│       ├── Config
│       ├── Container
│       └── Port
└── tests
    ├── Feature
    ├── Pest.php
    ├── TestCase.php
    └── Unit
```
