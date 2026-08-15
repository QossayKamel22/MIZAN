from __future__ import annotations

import sys
import time
import uuid
from pathlib import Path

from fastapi import APIRouter, Depends

from app.api.deps import get_internal_user_id
from app.core.config import Settings, get_settings
from app.core.errors import RateLimitedError
from app.schemas.ai import AskRequest, AskResponse, InsightResponse

# The AI agent layer lives in the sibling `ai/` package at the repo root
# (docs/AI_AGENT_ARCHITECTURE.md), imported here rather than called over
# HTTP to avoid an unnecessary network hop within one deployable unit
# (docs/SYSTEM_ARCHITECTURE.md §2.3).
_AI_PACKAGE_ROOT = Path(__file__).resolve().parents[5]
if str(_AI_PACKAGE_ROOT) not in sys.path:
    sys.path.insert(0, str(_AI_PACKAGE_ROOT))

from ai.agents.graph import run_agent  # noqa: E402

router = APIRouter()

# Simple in-process rate limiter (docs/API_SPECIFICATION.md §11). A
# Redis-backed limiter is documented as pending infra for multi-instance
# deployments (docs/SECURITY_REQUIREMENTS.md §11) — this in-process version
# is correct for a single backend instance today, not a placeholder.
_rate_limit_window_seconds = 60
_rate_limit_max_requests = 20
_request_log: dict[uuid.UUID, list[float]] = {}


def _check_rate_limit(user_id: uuid.UUID) -> None:
    now = time.time()
    history = _request_log.setdefault(user_id, [])
    history[:] = [t for t in history if now - t < _rate_limit_window_seconds]
    if len(history) >= _rate_limit_max_requests:
        raise RateLimitedError("Too many AI requests. Please wait a moment and try again.")
    history.append(now)


@router.post("/ask", response_model=AskResponse)
async def ask(
    payload: AskRequest,
    user_id: uuid.UUID = Depends(get_internal_user_id),
    settings: Settings = Depends(get_settings),
):
    _check_rate_limit(user_id)
    result = run_agent(
        user_id=str(user_id),
        question=payload.question,
        language="en",
        ai_configured=settings.ai_configured,
    )
    return AskResponse(
        answer=result["answer"], tools_used=result["tools_used"], language=result["language"]
    )


@router.get("/insights", response_model=InsightResponse)
async def insights(user_id: uuid.UUID = Depends(get_internal_user_id)):
    result = run_agent(
        user_id=str(user_id),
        question="__dashboard_insight__",
        language="en",
        ai_configured=False,
    )
    return InsightResponse(insights=[result["answer"]])
