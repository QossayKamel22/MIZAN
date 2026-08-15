from __future__ import annotations

from typing import TypedDict


class AgentState(TypedDict, total=False):
    """Shared state threaded through the LangGraph graph
    (docs/AI_AGENT_ARCHITECTURE.md §4). Every node reads/writes this dict;
    LangGraph merges node outputs into it between steps."""

    user_id: str
    question: str
    language: str  # "ar" | "en"
    intent: str | None
    tool_results: list[dict]
    answer: str | None
