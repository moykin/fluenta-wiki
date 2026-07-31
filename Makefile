# Fluenta — единая точка входа для всех задач разработки.
# `make` без аргументов покажет список команд.

.DEFAULT_GOAL := help
SHELL := /bin/bash

# ─────────────────────────── Помощь ───────────────────────────

help: ## Показать список команд
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

# ───────────────────── Локальная разработка ─────────────────────

db-up: ## Поднять локальную БД (Postgres + pgvector) в Docker
	docker compose -f infra/docker-compose.local.yml up -d
	@echo "Postgres: 127.0.0.1:5433 (db=fluenta, user=fluenta)"

db-down: ## Остановить локальную БД
	docker compose -f infra/docker-compose.local.yml down

db-reset: ## Снести локальную БД вместе с данными и поднять заново
	docker compose -f infra/docker-compose.local.yml down -v
	$(MAKE) db-up

api: ## Backend с автоперезагрузкой → http://127.0.0.1:8000 (доки /docs)
	cd backend && uv run uvicorn app.main:app --reload --port 8000

web: ## Маркетинг (Jaspr) с hot reload → http://127.0.0.1:8080
	cd marketing && dart run jaspr_cli:jaspr serve

app-web: ## Приложение в Chrome с hot reload
	cd app && flutter run -d chrome

app-macos: ## Приложение нативно на macOS
	cd app && flutter run -d macos

app-ios: ## Приложение на подключённом iPhone/iPad или симуляторе
	cd app && flutter run -d ios

app-android: ## Приложение на Android-устройстве или эмуляторе
	cd app && flutter run -d android

devices: ## Показать доступные устройства для запуска
	flutter devices

# ───────────────────────── Качество ─────────────────────────

fmt: ## Отформатировать весь код
	@if [ -d backend/app ]; then cd backend && uv run ruff format . && uv run ruff check --fix .; fi
	@if [ -f app/pubspec.yaml ]; then cd app && dart format .; fi
	@if [ -f marketing/pubspec.yaml ]; then cd marketing && dart format .; fi

lint: ## Проверить стиль и типы (без изменений файлов)
	@if [ -d backend/app ]; then cd backend && uv run ruff format --check . && uv run ruff check . && uv run mypy .; fi
	@if [ -f app/pubspec.yaml ]; then cd app && dart format --set-exit-if-changed --output=none . && flutter analyze; fi
	@if [ -f marketing/pubspec.yaml ]; then cd marketing && dart format --set-exit-if-changed --output=none . && dart analyze; fi

test: ## Прогнать все тесты
	@if [ -d backend/tests ]; then cd backend && uv run pytest -q; fi
	@if [ -f app/pubspec.yaml ]; then cd app && flutter test; fi

check: lint test ## Всё, что проверяет CI — прогнать локально перед push

# ──────────────────────── Безопасность ────────────────────────

secrets: ## Просканировать репозиторий и историю на утёкшие секреты
	gitleaks detect --source . --redact --verbose

deps-audit: ## Проверить зависимости на известные уязвимости
	@if [ -f backend/pyproject.toml ]; then cd backend && uv run pip-audit; fi
	@if [ -f app/pubspec.yaml ]; then cd app && flutter pub outdated; fi

hooks: ## Установить pre-commit хуки (делается один раз после клона)
	pre-commit install
	pre-commit install --hook-type commit-msg
	@echo "Хуки установлены. Проверить всё сразу: make hooks-run"

hooks-run: ## Прогнать pre-commit по всем файлам
	pre-commit run --all-files

# ───────────────────────── Сборка ─────────────────────────

build-web: ## Собрать Flutter web в релизе
	cd app && flutter build web --release --wasm

build-marketing: ## Собрать статику маркетинга (Jaspr SSG)
	cd marketing && dart run jaspr_cli:jaspr build

# ───────────────────────── Деплой ─────────────────────────

deploy-dev: ## Выкатить текущий main на dev-стенд (обычно это делает CI)
	gh workflow run deploy.yml -f environment=dev

deploy-prod: ## Выкатить на прод (требует подтверждения в GitHub)
	gh workflow run deploy.yml -f environment=prod

logs-dev: ## Логи dev-стенда
	ssh $(SERVER) 'cd /opt/fluenta && docker compose logs -f --tail=100 api-dev'

logs-prod: ## Логи прода
	ssh $(SERVER) 'cd /opt/fluenta && docker compose logs -f --tail=100 api-prod'

.PHONY: help db-up db-down db-reset api web app-web app-macos app-ios app-android devices \
        fmt lint test check secrets deps-audit hooks hooks-run build-web build-marketing \
        deploy-dev deploy-prod logs-dev logs-prod
