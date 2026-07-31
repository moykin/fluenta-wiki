# Многоступенчатая сборка: в финальном образе нет ни компилятора,
# ни менеджера пакетов — меньше поверхность атаки и меньше вес.

FROM python:3.14-slim AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

# Слой с зависимостями кешируется отдельно от кода: правка исходников
# не заставляет пересобирать всё окружение.
COPY pyproject.toml uv.lock* ./
RUN uv sync --frozen --no-dev --no-install-project 2>/dev/null || uv sync --no-dev --no-install-project

COPY app ./app
RUN uv sync --frozen --no-dev 2>/dev/null || uv sync --no-dev


FROM python:3.14-slim

# Приложение работает не от root: если контейнер скомпрометируют,
# у процесса не должно быть прав что-то менять в системе.
RUN useradd --create-home --uid 10001 fluenta

WORKDIR /app
COPY --from=builder --chown=fluenta:fluenta /app /app

ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER fluenta
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/healthz')"

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
