# Архитектура Fluenta

> Живой документ. Обновлять при каждом решении по стеку. Обновлено: **2026-07-31**.

## Целевые платформы

| Поверхность | Технология | Статус |
|---|---|---|
| Веб — телефон / планшет / ПК (приложение) | Flutter Web | решено |
| iOS + iPadOS | Flutter | решено |
| Android | Flutter | решено |
| macOS | Flutter (нативный desktop-таргет) | решено |
| Лендинг, тарифы, SEO-куст, «О проекте» | Jaspr (Dart, SSG + partial hydration) — **см. «Открытый вопрос 1»** | требует подтверждения |
| Backend / API / голосовой релей | Python + FastAPI | решено |
| БД | PostgreSQL 16 + pgvector | решено |

## Фронтенд — Flutter

Один код на web, iOS, iPadOS, Android, macOS. Flutter — единственный из рассмотренных вариантов, который даёт **нативный macOS-таргет** без обходных путей (у React Native macOS сырой, у Capacitor — только через Electron).

**Стек внутри приложения:**

| Задача | Пакет / решение |
|---|---|
| Состояние | Riverpod |
| Навигация | go_router + адаптивный shell (bottom tabs → rail → sidebar) |
| Локальная БД, офлайн-first | drift (SQLite; на web — sqlite3 WASM) |
| Сеть | dio + клиент, **сгенерированный из OpenAPI** бэкенда |
| Аудио запись / воспроизведение | record + just_audio |
| Реальное время (голос) | web_socket_channel → релей на бэкенде |
| Шрифты | Source Serif 4 + Inter, **бандлятся в приложение** (не CDN — нужен офлайн) |
| Тема | токены дизайн-системы в `ThemeExtension` (см. `design/README.md`) |

**Адаптив.** Дизайн сделан fluid-вёрсткой (`clamp()`, `auto-fit` сетки). Во Flutter это переносится как `LayoutBuilder` + брейкпоинты **640 / 1024 / 1440**; онбординг имеет три лэйаута (телефон 390, планшет 834, ПК двухколоночный) — это один экранный поток, а не три экрана.

**Риски Flutter, которые надо держать в голове:**
1. **Читалка** — ядро продукта: тап/hover по слову, выделение фрагмента, серифная типографика 17.5–18.5px / line-height 1.72. Во Flutter это `Text.rich` + `WidgetSpan` + кастомные жесты; выделение произвольного диапазона сложнее, чем в DOM. Прототипировать **до** остальных экранов.
2. **Web-сборка тяжёлая** (CanvasKit ~1.5–2.5 МБ) и не индексируется поисковиками — отсюда «Открытый вопрос 1».
3. Тач-цели ≥44px и `prefers-reduced-motion` — в макетах учтены, во Flutter надо воспроизводить руками.

## Бэкенд — Python / FastAPI

**Почему Python, а не Node/TS:**

1. **Единого языка с фронтом не будет в любом случае** — Flutter пишется на Dart. Главный аргумент за Node («один язык на весь стек») исчезает.
2. **Ядро продукта — NLP.** Разбор «почему такой перевод» (грамматика, base form → used form) строится на **spaCy + spacy-llm**. Это Python-нативно; на Node пришлось бы держать второй рантайм только ради этого.
3. **FSRS** — референсная реализация `py-fsrs` (Python).
4. **Gemini Flash Live** — зрелый Python SDK `google-genai`; WebSocket-релей пишется прямо на Starlette/FastAPI.
5. **pgvector** — SQLAlchemy 2 + `pgvector`, RAG без отдельного Chroma.
6. **Память сервера.** CPX21 = 4 ГБ RAM. Один рантайм (uvicorn) + Postgres дешевле, чем Node + Python рядом.

**Единственный минус — нет общих типов с Dart.** Лечится полностью: FastAPI отдаёт OpenAPI-схему, из неё в CI генерируется типизированный Dart-клиент. Типобезопасность фронт↔бэк восстанавливается автоматически.

**Стек бэкенда:**

| Задача | Решение |
|---|---|
| API | FastAPI + uvicorn (gunicorn workers) |
| БД / ORM / миграции | PostgreSQL 16 + pgvector, SQLAlchemy 2, Alembic |
| Аутентификация | JWT (access + refresh), argon2 для паролей |
| Голосовой релей | WebSocket `/v1/voice/session` → Gemini Flash Live. **Ключ Gemini живёт только на сервере**, клиент его не видит никогда |
| Учёт голосовых минут и гейтинг | **только на сервере** — клиенту доверять нельзя |
| Грамматический разбор | spaCy + spacy-llm (без локальных transformer-моделей — экономия RAM) |
| Повторения | py-fsrs |
| Фоновые задачи | сначала FastAPI background tasks; при росте — arq/Celery |

## Инфраструктура

Docker Compose на одном сервере (см. `INFRA.local.md` — он gitignored):

- **Caddy** — авто-TLS для `fluenta.wiki`, реверс-прокси.
- **api** — FastAPI.
- **postgres** — Postgres 16 + pgvector.
- Все внутренние порты биндятся **на `127.0.0.1`**: Docker публикует порты в обход UFW, иначе БД торчит наружу.
- Секреты — через `env_file` вне репозитория. В репо только `.env.example` с плейсхолдерами.

**Регион:** сервер остаётся в **US-West (Hillsboro, OR)** — решение принято 2026-07-31. Следствие: для EU/СНГ RTT ≈ 260 мс, голосовой тьютор реального времени будет ощутимо задержан. Если целевая аудитория окажется европейской — вернуться к вопросу EU-релея.

## Окружение разработки

Проверено 2026-07-31 на машине разработчика — `flutter doctor` без замечаний:

| Инструмент | Версия |
|---|---|
| Flutter | 3.41.7 (stable) |
| Dart | 3.11.5 |
| Xcode (iOS + macOS) | 26.6 |
| Android SDK | 37.0.0 |
| Chrome (web-таргет) | ✓ |
| Python / Node / Docker / CocoaPods | установлены |

Все пять целевых платформ собираются локально без дополнительной настройки. Единственное, что понадобится включить перед Э2: **Developer Mode на iPhone и iPad** — иначе они видны в сети, но не принимают сборки по воздуху (либо подключать кабелем).

## Открытые вопросы

**1. Чем делать маркетинг и SEO-куст. → Рекомендация: Jaspr (Dart)**

У проекта серьёзный SEO-куст (`SEO Pillar`, `Texts`, `Texts B1`, `Grammar`, `Video`, `Career`) плюс лендинг, тарифы и «О проекте» — это основной канал привлечения.

*Почему не Flutter Web.* С версии 3.29 HTML-рендерер удалён, остались только `canvaskit` и `skwasm` — весь текст рисуется в `<canvas>`, в DOM нет ни заголовков, ни абзацев. Документация Flutter формулирует это прямо: «Flutter web prioritizes performance, fidelity, and consistency. This means application output doesn't align with what search engines need to properly index» и «At this time, Flutter is not suitable for static websites with text-rich flow-based content». Официальная рекомендация той же страницы — либо Jaspr, либо отделить маркетинг в SEO-оптимизированный HTML.

*Почему Jaspr, а не Astro.* Jaspr — веб-фреймворк **на Dart**: рендерит настоящий HTML/CSS, умеет SSG, SSR и partial hydration (страница статична, JS подключается только к интерактивным островкам). Язык остаётся один на весь проект — общие модели, токены и валидация с приложением, второй экосистемы не появляется. Команда Flutter перевела на Jaspr `flutter.dev`, `dart.dev` и `docs.flutter.dev`; Google инвестирует в проект напрямую.

*Бонус для лендинга.* Пакет `jaspr_flutter_embed` позволяет встроить настоящий Flutter-виджет в статическую страницу. Живое демо читалки на лендинге можно собрать из того же кода, что и в приложении, не жертвуя индексируемостью самой страницы.

*Риск.* Jaspr пока pre-1.0 (`jaspr ^0.23.x`) — API может меняться. Смягчается тем, что на нём работают продовые сайты Flutter и Google в него вкладывается.

Раскладка на домене: `fluenta.wiki/*` — Jaspr (маркетинг и SEO), `fluenta.wiki/app/*` — Flutter (приложение).

Источники: [docs.flutter.dev — Web FAQ](https://docs.flutter.dev/platform-integration/web/faq) · [Flutter Blog — We rebuilt Flutter's websites with Dart and Jaspr](https://flutter.dev/blog/we-rebuilt-flutters-websites-with-dart-and-jaspr) · [docs.jaspr.site](https://docs.jaspr.site/)

**2. Платежи в мобильных сторах.**
Apple и Google требуют использовать их встроенные покупки для цифрового контента — комиссия 15–30%. Тарифы (Pro 150 мин/мес, пакеты +60 / +180 мин) на iOS/Android должны быть оформлены как IAP, а в вебе — через внешнего провайдера (Stripe/Paddle). Учёт минут при этом остаётся единым на сервере. Решить до реализации paywall.

**3. On-device перевод для hover/tap.**
Задумано мгновенное локальное срабатывание без запроса к серверу. Во Flutter это либо бандл словарей, либо лёгкая модель через FFI. Решить при работе над читалкой.

## Связанные документы

[PROJECT.md](PROJECT.md) · [ROADMAP.md](ROADMAP.md) · [REPO.md](REPO.md) · [SECURITY.md](SECURITY.md) · [POSITIONING.md](POSITIONING.md) · `design/README.md` (дизайн-хэндофф) · `INFRA.local.md` (локальный, вне репо)
