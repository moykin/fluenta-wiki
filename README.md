# Fluenta

**Fluenta превращает то, что вы читаете, в то, что вы можете сказать.**

Приложение для изучения языка вокруг одного цикла: читать → понять «почему» → пересказать вслух → получить одну правку → повторить, когда начинаешь забывать.

Веб (телефон, планшет, ПК) + приложения для iOS, iPadOS, Android и macOS.

## Стек

| Слой | Технология |
|---|---|
| Приложение | Flutter — web, iOS, iPadOS, Android, macOS |
| Лендинг и SEO | Jaspr (Dart) — статическая генерация + partial hydration |
| Backend | Python + FastAPI |
| База данных | PostgreSQL 16 + pgvector |
| Голос | Gemini Flash Live через серверный релей |
| Разбор грамматики | spaCy + spacy-llm |
| Повторения | FSRS |

## Структура

```
app/        — Flutter-приложение (все платформы)
backend/    — FastAPI: API, голосовой релей, разбор текста
marketing/  — лендинг и SEO-страницы (Jaspr)
design/     — дизайн-хэндофф: макеты, токены, ассеты
infra/      — docker-compose, Caddy, провижн сервера
docs/       — документация проекта
```

## Быстрый старт

```bash
make hooks     # pre-commit хуки, включая сканер секретов
make db-up     # локальная база в Docker
make api       # backend  → 127.0.0.1:8000
make app-web   # приложение в браузере
```

`make` без аргументов покажет все команды.

## Документация

- [docs/PROJECT.md](docs/PROJECT.md) — что за продукт, фичи, монетизация
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — стек, решения и их обоснование, открытые вопросы
- [docs/ROADMAP.md](docs/ROADMAP.md) — план работ по этапам
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) — локальная разработка: как видеть результат
- [docs/OPERATIONS.md](docs/OPERATIONS.md) — окружения, dev-стенд, деплой, откат
- [docs/QUALITY.md](docs/QUALITY.md) — стандарты кода, тесты, бюджеты производительности
- [docs/SECURITY.md](docs/SECURITY.md) — секреты и операционная безопасность
- [docs/REPO.md](docs/REPO.md) — устройство репозитория
- [docs/POSITIONING.md](docs/POSITIONING.md) — посыл и тон
- [design/README.md](design/README.md) — дизайн-хэндофф: экраны, токены, состояния

## Статус

Дизайн готов (34 экрана high-fidelity). Разработка на старте — см. [ROADMAP.md](docs/ROADMAP.md).
