# Fluenta

**Fluenta превращает то, что вы читаете, в то, что вы можете сказать.**

Приложение для изучения языка вокруг одного цикла: читать → понять «почему» → пересказать вслух → получить одну правку → повторить, когда начинаешь забывать.

Веб (телефон, планшет, ПК) + приложения для iOS, iPadOS, Android и macOS.

## Стек

| Слой | Технология |
|---|---|
| Приложение | Flutter — web, iOS, iPadOS, Android, macOS |
| Backend | Python + FastAPI |
| База данных | PostgreSQL 16 + pgvector |
| Голос | Gemini Flash Live через серверный релей |
| Разбор грамматики | spaCy + spacy-llm |
| Повторения | FSRS |

## Структура

```
app/        — Flutter-приложение (все платформы)
backend/    — FastAPI: API, голосовой релей, разбор текста
marketing/  — лендинг и SEO-страницы
design/     — дизайн-хэндофф: макеты, токены, ассеты
infra/      — docker-compose, Caddy, провижн сервера
docs/       — документация проекта
```

## Документация

- [docs/PROJECT.md](docs/PROJECT.md) — что за продукт, фичи, монетизация
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — стек, решения и их обоснование, открытые вопросы
- [docs/ROADMAP.md](docs/ROADMAP.md) — план работ по этапам
- [docs/REPO.md](docs/REPO.md) — устройство репозитория
- [docs/SECURITY.md](docs/SECURITY.md) — правила работы с секретами
- [docs/POSITIONING.md](docs/POSITIONING.md) — посыл и тон
- [design/README.md](design/README.md) — дизайн-хэндофф: экраны, токены, состояния

## Статус

Дизайн готов (34 экрана high-fidelity). Разработка на старте — см. [ROADMAP.md](docs/ROADMAP.md).
