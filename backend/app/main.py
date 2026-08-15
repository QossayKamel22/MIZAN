from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1.router import api_router
from app.core.config import get_settings
from app.core.errors import DomainError, domain_error_handler, unhandled_error_handler
from app.core.logging import configure_logging
from app.schemas.common import HealthResponse


def create_app() -> FastAPI:
    settings = get_settings()
    configure_logging(settings.app_debug)

    app = FastAPI(
        title=settings.app_name,
        description="MIZAN backend API — see docs/API_SPECIFICATION.md",
        version="0.1.0",
        debug=settings.app_debug,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins_list,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    app.add_exception_handler(DomainError, domain_error_handler)
    app.add_exception_handler(Exception, unhandled_error_handler)

    app.include_router(api_router)

    @app.get("/health", response_model=HealthResponse, tags=["health"])
    async def health() -> HealthResponse:
        return HealthResponse(app_name=settings.app_name, app_env=settings.app_env)

    return app


app = create_app()
