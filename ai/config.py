import os
from dataclasses import dataclass


@dataclass
class AiConfig:
    """AI layer configuration (docs/AI_AGENT_ARCHITECTURE.md §2). Read from
    the same environment variables documented in the root `.env.example` —
    this package does not duplicate secret storage."""

    provider: str = os.getenv("AI_PROVIDER", "anthropic")
    model_name: str = os.getenv("AI_MODEL_NAME", "claude-sonnet-4-5")
    anthropic_api_key: str = os.getenv("ANTHROPIC_API_KEY", "")
    openai_api_key: str = os.getenv("OPENAI_API_KEY", "")
    timeout_seconds: int = int(os.getenv("AI_AGENT_TIMEOUT_SECONDS", "30"))

    @property
    def is_configured(self) -> bool:
        return bool(self.anthropic_api_key or self.openai_api_key)
