from __future__ import annotations

from abc import ABC, abstractmethod
from datetime import date, timedelta


class FinanceDataProvider(ABC):
    """Interface every agent tool depends on (docs/AI_AGENT_ARCHITECTURE.md
    §5). Tools never touch the database directly — they call this interface,
    which the production wiring implements against
    `backend/app/repositories/*` (same data-access code the REST API uses,
    so the agent and the API never disagree about a user's numbers).

    `FixtureDataProvider` below is the default implementation used when no
    production provider is injected (local dev, tests, or a request where
    the backend DB session isn't available to this synchronous agent call).
    This is intentionally a clearly-labeled fixture, not a claim of live
    data — see docs/AI_AGENT_ARCHITECTURE.md §6 "Future / Pending".
    """

    @abstractmethod
    def get_spending_by_category(self, user_id: str, period_start: date, period_end: date) -> dict[str, float]:
        ...

    @abstractmethod
    def get_income_vs_expense(self, user_id: str, period_start: date, period_end: date) -> dict[str, float]:
        ...

    @abstractmethod
    def get_budget_status(self, user_id: str) -> list[dict]:
        ...

    @abstractmethod
    def get_upcoming_bills(self, user_id: str, horizon_days: int) -> list[dict]:
        ...

    @abstractmethod
    def get_goal_progress(self, user_id: str) -> list[dict]:
        ...


class FixtureDataProvider(FinanceDataProvider):
    """Deterministic fixture data for local development, unit tests, and
    the AI eval set (ai/tests/eval_questions.json) — not connected to a
    real user's data. Swapping to `BackendFinanceDataProvider` (production,
    to be added once the FastAPI service is deployed and this package runs
    with DB access) is the only change needed to make answers live."""

    def get_spending_by_category(self, user_id: str, period_start: date, period_end: date) -> dict[str, float]:
        return {"Groceries": 850.0, "Dining": 320.0, "Transport": 210.0}

    def get_income_vs_expense(self, user_id: str, period_start: date, period_end: date) -> dict[str, float]:
        return {"income": 12000.0, "expense": 1380.0}

    def get_budget_status(self, user_id: str) -> list[dict]:
        return [
            {
                "category": "Groceries",
                "limit": 1500.0,
                "spent": 850.0,
                "percent_used": 850.0 / 1500.0,
            }
        ]

    def get_upcoming_bills(self, user_id: str, horizon_days: int) -> list[dict]:
        today = date.today()
        return [
            {"payee": "DEWA (Electricity & Water)", "amount": 420.0, "due_date": str(today + timedelta(days=3))},
            {"payee": "Etisalat", "amount": 199.0, "due_date": str(today + timedelta(days=6))},
        ]

    def get_goal_progress(self, user_id: str) -> list[dict]:
        return [{"name": "Emergency Fund", "target": 20000.0, "current": 6500.0}]
