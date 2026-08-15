from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Backend configuration, sourced entirely from environment variables
    (docs/SECURITY_REQUIREMENTS.md §5) — never hardcoded, never committed.
    See root `.env.example` for the full documented variable list.
    """

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_env: str = "development"
    app_name: str = "MIZAN"
    app_debug: bool = True

    api_host: str = "0.0.0.0"
    api_port: int = 8000
    api_secret_key: str = "change-me-in-production"
    api_algorithm: str = "HS256"

    database_url: str = "postgresql+asyncpg://mizan:mizan@localhost:5432/mizan_db"

    firebase_project_id: str = ""
    firebase_private_key_id: str = ""
    firebase_private_key: str = ""
    firebase_client_email: str = ""
    firebase_client_id: str = ""

    ai_provider: str = "anthropic"
    anthropic_api_key: str = ""
    openai_api_key: str = ""
    ai_model_name: str = "claude-sonnet-4-5"
    ai_agent_timeout_seconds: int = 30

    cors_allowed_origins: str = "http://localhost:3000"

    @property
    def cors_origins_list(self) -> list[str]:
        return [o.strip() for o in self.cors_allowed_origins.split(",") if o.strip()]

    @property
    def firebase_configured(self) -> bool:
        """Whether real Firebase credentials are present. Used to decide
        whether to initialize the Firebase Admin SDK or fall back to a
        documented no-op verifier in local/dev without a live project
        (see app/core/security.py)."""
        return bool(self.firebase_project_id and self.firebase_private_key)

    @property
    def ai_configured(self) -> bool:
        """Whether a live LLM provider key is present
        (docs/AI_AGENT_ARCHITECTURE.md §6 — pending until set)."""
        return bool(self.anthropic_api_key or self.openai_api_key)


@lru_cache
def get_settings() -> Settings:
    return Settings()
