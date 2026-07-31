"""Настройки приложения.

Всё читается из переменных окружения — в коде не должно быть ни одного
значения, зависящего от окружения. Секреты живут только в `.env` на
сервере и никогда не попадают в репозиторий.
"""

from functools import lru_cache
from typing import Literal

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_env: Literal["development", "production", "test"] = "development"

    database_url: str = "postgresql+asyncpg://fluenta:localdev@127.0.0.1:5433/fluenta"

    # Список источников через запятую. Звёздочка не используется намеренно:
    # приложение работает с микрофоном и токенами, здесь нельзя быть щедрым.
    cors_origins: str = "http://localhost:8080"

    @property
    def cors_origin_list(self) -> list[str]:
        return [origin.strip() for origin in self.cors_origins.split(",") if origin.strip()]

    @property
    def is_production(self) -> bool:
        return self.app_env == "production"


@lru_cache
def get_settings() -> Settings:
    """Настройки читаются один раз за время жизни процесса."""
    return Settings()
