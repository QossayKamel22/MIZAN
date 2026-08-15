from __future__ import annotations

from datetime import date

from ai.agents.state import AgentState
from ai.tools.data_provider import FinanceDataProvider
from ai.tools.finance_tools import get_goal_progress, get_income_vs_expense


def run(state: AgentState, provider: FinanceDataProvider) -> AgentState:
    today = date.today()
    period_start = today.replace(day=1)
    tool_results = list(state.get("tool_results", []))
    tool_results.append(get_income_vs_expense(provider, state["user_id"], period_start, today))
    tool_results.append(get_goal_progress(provider, state["user_id"]))
    return {**state, "tool_results": tool_results}
