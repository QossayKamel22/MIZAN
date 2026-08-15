from __future__ import annotations

from datetime import date

from ai.tools.data_provider import FinanceDataProvider


def get_spending_by_category(provider: FinanceDataProvider, user_id: str, period_start: date, period_end: date) -> dict:
    """Tool: category-level expense breakdown (docs/AI_AGENT_ARCHITECTURE.md §5)."""
    breakdown = provider.get_spending_by_category(user_id, period_start, period_end)
    return {"tool": "get_spending_by_category", "data": breakdown}


def get_income_vs_expense(provider: FinanceDataProvider, user_id: str, period_start: date, period_end: date) -> dict:
    data = provider.get_income_vs_expense(user_id, period_start, period_end)
    return {"tool": "get_income_vs_expense", "data": data}


def get_budget_status(provider: FinanceDataProvider, user_id: str) -> dict:
    data = provider.get_budget_status(user_id)
    return {"tool": "get_budget_status", "data": data}


def get_upcoming_bills(provider: FinanceDataProvider, user_id: str, horizon_days: int = 14) -> dict:
    data = provider.get_upcoming_bills(user_id, horizon_days)
    return {"tool": "get_upcoming_bills", "data": data}


def get_goal_progress(provider: FinanceDataProvider, user_id: str) -> dict:
    data = provider.get_goal_progress(user_id)
    return {"tool": "get_goal_progress", "data": data}
