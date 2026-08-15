from __future__ import annotations

from datetime import date

from ai.agents.state import AgentState
from ai.tools.data_provider import FinanceDataProvider
from ai.tools.finance_tools import get_spending_by_category


def run(state: AgentState, provider: FinanceDataProvider) -> AgentState:
    today = date.today()
    period_start = today.replace(day=1)
    result = get_spending_by_category(provider, state["user_id"], period_start, today)
    tool_results = list(state.get("tool_results", []))
    tool_results.append(result)
    return {**state, "tool_results": tool_results}
