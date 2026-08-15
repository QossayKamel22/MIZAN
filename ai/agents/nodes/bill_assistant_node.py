from __future__ import annotations

from ai.agents.state import AgentState
from ai.tools.data_provider import FinanceDataProvider
from ai.tools.finance_tools import get_upcoming_bills


def run(state: AgentState, provider: FinanceDataProvider) -> AgentState:
    result = get_upcoming_bills(provider, state["user_id"], horizon_days=14)
    tool_results = list(state.get("tool_results", []))
    tool_results.append(result)
    return {**state, "tool_results": tool_results}
