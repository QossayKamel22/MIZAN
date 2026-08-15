import uuid
from datetime import date
from unittest.mock import AsyncMock

import pytest

from app.schemas.budget import BudgetCreate, BudgetPeriod
from app.services.budget_service import BudgetService


class _FakeBudget:
    def __init__(self, **kwargs):
        self.id = uuid.uuid4()
        self.category_id = kwargs.get("category_id")
        self.limit_amount = kwargs["limit_amount"]
        self.period_type = kwargs["period_type"]
        self.period_start = kwargs["period_start"]
        self.period_end = kwargs["period_end"]
        self.alert_thresholds = kwargs.get("alert_thresholds", [80, 100])
        self.status = "active"
        self.created_at = "2026-08-01T00:00:00Z"


@pytest.mark.asyncio
async def test_create_budget_computes_spent_and_remaining():
    budget_repo = AsyncMock()
    budget_repo.create.return_value = _FakeBudget(
        limit_amount=1000,
        period_type="monthly",
        period_start=date(2026, 8, 1),
        period_end=date(2026, 8, 31),
    )
    transaction_repo = AsyncMock()
    transaction_repo.sum_expenses_in_period.return_value = 400.0

    service = BudgetService(budget_repo, transaction_repo)
    payload = BudgetCreate(
        limit_amount=1000,
        period_type=BudgetPeriod.monthly,
        period_start=date(2026, 8, 1),
        period_end=date(2026, 8, 31),
    )
    result = await service.create_budget("user-1", payload)

    assert result.spent_amount == 400.0
    assert result.remaining_amount == 600.0
    assert result.percent_used == 0.4


@pytest.mark.asyncio
async def test_create_budget_rejects_invalid_period():
    from app.core.errors import ValidationError

    budget_repo = AsyncMock()
    transaction_repo = AsyncMock()
    service = BudgetService(budget_repo, transaction_repo)

    payload = BudgetCreate(
        limit_amount=500,
        period_type=BudgetPeriod.monthly,
        period_start=date(2026, 8, 31),
        period_end=date(2026, 8, 1),  # invalid: before start
    )
    with pytest.raises(ValidationError):
        await service.create_budget("user-1", payload)
