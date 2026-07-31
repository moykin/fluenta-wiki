"""Точка входа API.

Пока здесь только проверка живости — каркас, на который дальше
наращиваются разделы: аккаунты, тексты, разбор, голосовой релей,
повторения. Порядок появления — в `docs/ROADMAP.md`.
"""

from typing import Literal

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from app.config import Settings, get_settings

__version__ = "0.1.0"


class HealthResponse(BaseModel):
    """Ответ проверки живости.

    Намеренно не содержит ничего об окружении, версиях библиотек и
    состоянии внутренних сервисов: этот адрес открыт наружу, и лишние
    подробности здесь — это подсказка тому, кто изучает чужой сервис.
    """

    status: Literal["ok"] = "ok"
    version: str = __version__


def create_app(settings: Settings | None = None) -> FastAPI:
    """Собирает приложение.

    Настройки передаются параметром, чтобы в тестах можно было поднять
    приложение с другим окружением, не трогая переменные процесса.
    """
    config = settings or get_settings()

    app = FastAPI(
        title="Fluenta API",
        version=__version__,
        # В проде скрываем интерактивную документацию: схема API — это
        # карта поверхности атаки, наружу её отдавать незачем.
        docs_url=None if config.is_production else "/docs",
        redoc_url=None,
        openapi_url=None if config.is_production else "/openapi.json",
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=config.cors_origin_list,
        allow_credentials=True,
        allow_methods=["GET", "POST", "PATCH", "DELETE"],
        allow_headers=["Authorization", "Content-Type"],
    )

    @app.get("/healthz", response_model=HealthResponse, tags=["service"])
    async def healthz() -> HealthResponse:
        """Проверка живости для балансировщика и деплоя."""
        return HealthResponse()

    return app


app = create_app()
