# Makefile
.DEFAULT_GOAL := help

# --- Configuração ---
ENV_TEMPLATE_DIR := _env/dev
DOCKERFILE_TEMPLATE_NAME := Dockerfile
DOCKER_COMPOSE_TEMPLATE_NAME := docker-compose.yml
ENV_FILE_TEMPLATE_NAME := dev.env
ALIASES_TEMPLATE_NAME := .project_aliases.example.sh

DOCKERFILE_SOURCE := $(ENV_TEMPLATE_DIR)/$(DOCKERFILE_TEMPLATE_NAME)
DOCKER_COMPOSE_SOURCE := $(ENV_TEMPLATE_DIR)/$(DOCKER_COMPOSE_TEMPLATE_NAME)
ENV_FILE_SOURCE := $(ENV_TEMPLATE_DIR)/$(ENV_FILE_TEMPLATE_NAME)
ALIASES_SOURCE := $(ENV_TEMPLATE_DIR)/$(ALIASES_TEMPLATE_NAME)

ROOT_DOCKERFILE_TARGET := ./Dockerfile
ROOT_DOCKER_COMPOSE_TARGET := ./docker-compose.yml
ROOT_ENV_FILE_TARGET := ./.env
ROOT_ALIASES_TARGET := ./.project_aliases.sh

.PHONY: help default setup-dev clean-dev check-templates up down logs stats shell composer test goose migrate-up migrate-down migrate-reset migrate-create

# --- Comandos do Ambiente Docker ---
up: setup-dev
	@echo "INFO: Subindo os containers Docker..."
	@docker compose up -d --build

down:
	@echo "INFO: Parando os containers Docker..."
	@docker compose down --remove-orphans

logs:
	@echo "INFO: Exibindo logs da API (Pressione Ctrl+C para sair)..."
	@docker compose logs -f vortex-api

stats:
	@echo "INFO: Exibindo estatísticas dos containers..."
	@docker compose stats

# --- Comandos da Aplicação (executados dentro do container) ---
shell:
	@docker compose exec vortex-api sh

composer:
	@docker compose exec vortex-api composer $(filter-out $@,$(MAKECMDGOALS))

test:
	@make composer command=test

# --- Comandos de Migração (Goose) ---
goose:
	@docker compose exec vortex-api goose $(filter-out $@,$(MAKECMDGOALS))

migrate-up:
	@make goose command=up

migrate-down:
	@make goose command=down

migrate-reset:
	@make goose command=reset

migrate-create:
	@echo "INFO: Criando nova migração..."
	@docker compose exec vortex-api goose create $(filter-out $@,$(MAKECMDGOALS)) sql

# --- Comandos de Setup ---
setup-dev: check-templates
	@echo "INFO: Iniciando configuração do ambiente de desenvolvimento..."
	@cp "$(DOCKERFILE_SOURCE)" "$(ROOT_DOCKERFILE_TARGET)"
	@cp "$(DOCKER_COMPOSE_SOURCE)" "$(ROOT_DOCKER_COMPOSE_TARGET)"
	@ > "$(ROOT_ENV_FILE_TARGET)"
	@echo "# Arquivo gerado por 'make setup-dev' em $$(date)." >> "$(ROOT_ENV_FILE_TARGET)"
	@CURRENT_UID=$$(id -u) ; \
	CURRENT_GID=$$(id -g) ; \
	sed -e "s/^HOST_UID=.*/HOST_UID=$${CURRENT_UID}/" \
	    -e "s/^HOST_GID=.*/HOST_GID=$${CURRENT_GID}/" \
	    "$(ENV_FILE_SOURCE)" >> "$(ROOT_ENV_FILE_TARGET)"
	@echo "      '$(ROOT_ENV_FILE_TARGET)' gerado com HOST_UID=$$(id -u) e HOST_GID=$$(id -g)."
	@cp "$(ALIASES_SOURCE)" "$(ROOT_ALIASES_TARGET)"
	@echo "INFO: Configuração concluída."

clean-dev:
	@echo "INFO: Removendo arquivos de ambiente da raiz..."
	@rm -f $(ROOT_DOCKERFILE_TARGET) $(ROOT_DOCKER_COMPOSE_TARGET) $(ROOT_ENV_FILE_TARGET) $(ROOT_ALIASES_TARGET)
	@echo "INFO: Limpeza concluída."

check-templates:
	@missing_files=0; \
	for template_file in $(DOCKERFILE_SOURCE) $(DOCKER_COMPOSE_SOURCE) $(ENV_FILE_SOURCE) $(ALIASES_SOURCE); do \
		if [ ! -f "$$template_file" ]; then \
			echo "ERRO: Template NÃO ENCONTRADO: $$template_file"; \
			missing_files=1; \
		fi; \
	done; \
	if [ $$missing_files -eq 1 ]; then \
		exit 1; \
	fi

help:
	@echo "Uso: make [comando]"
	@echo ""
	@echo "Comandos de Gerenciamento do Ambiente:"
	@echo "  setup-dev      - Copia e configura os arquivos de ambiente na raiz do projeto."
	@echo "  clean-dev      - Remove os arquivos de ambiente gerados da raiz."
	@echo "  up             - Constrói e sobe os containers em background."
	@echo "  down           - Para e remove os containers e a rede."
	@echo "  logs           - Exibe os logs do serviço da API em tempo real."
	@echo "  stats          - Mostra o uso de recursos (CPU, Memória) dos containers."
	@echo ""
	@echo "Comandos de Desenvolvimento:"
	@echo "  shell          - Acessa o terminal (shell) do container da API."
	@echo "  composer ...   - Executa qualquer comando do Composer dentro do container."
	@echo "  test           - Roda a suíte de testes do PHPUnit."
	@echo ""
	@echo "Comandos de Migração (Goose):"
	@echo "  migrate-up     - Aplica todas as migrações pendentes."
	@echo "  migrate-down   - Reverte a última migração aplicada."
	@echo "  migrate-reset  - Reverte todas as migrações."
	@echo "  migrate-create <nome> - Cria um novo arquivo de migração SQL."
