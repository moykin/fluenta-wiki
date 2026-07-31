import pytest
from httpx import ASGITransport, AsyncClient

from app.config import Settings
from app.main import create_app


def _client(settings: Settings) -> AsyncClient:
    app = create_app(settings)
    return AsyncClient(transport=ASGITransport(app=app), base_url="http://test")


@pytest.fixture
def dev_settings() -> Settings:
    return Settings(app_env="test", cors_origins="http://localhost:8080")


@pytest.fixture
def prod_settings() -> Settings:
    return Settings(app_env="production", cors_origins="https://fluenta.wiki")


async def test_healthz_отвечает(dev_settings: Settings) -> None:
    async with _client(dev_settings) as client:
        response = await client.get("/healthz")

    assert response.status_code == 200
    assert response.json()["status"] == "ok"


async def test_healthz_не_раскрывает_окружение(prod_settings: Settings) -> None:
    """Проверка живости не должна выдавать наружу лишних подробностей."""
    async with _client(prod_settings) as client:
        response = await client.get("/healthz")

    body = response.json()
    assert set(body) == {"status", "version"}


async def test_документация_закрыта_в_проде(prod_settings: Settings) -> None:
    async with _client(prod_settings) as client:
        assert (await client.get("/docs")).status_code == 404
        assert (await client.get("/openapi.json")).status_code == 404


async def test_документация_открыта_в_разработке(dev_settings: Settings) -> None:
    async with _client(dev_settings) as client:
        assert (await client.get("/openapi.json")).status_code == 200


def test_список_источников_cors_разбирается() -> None:
    settings = Settings(cors_origins="https://fluenta.wiki, https://app.fluenta.wiki ,")

    assert settings.cors_origin_list == [
        "https://fluenta.wiki",
        "https://app.fluenta.wiki",
    ]


def test_признак_прода() -> None:
    assert Settings(app_env="production").is_production is True
    assert Settings(app_env="development").is_production is False
