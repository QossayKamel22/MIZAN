from __future__ import annotations

import uuid
from datetime import date

from app.core.errors import NotFoundError, ValidationError
from app.repositories.budget_repository import BudgetRepository
from app.repositories.transaction_repository import TransactionRepository
from app.schemas.budget import BudgetCreate, BudgetRead


class BudgetService:
    """Owns budget spend calculation and threshold-alert logic
    (docs/FUNCTIONAL_REQUIREMENTS.md FR-BUDGET-*, UC-5). The Flutter local
    mock store's `_recalculateBudgets` mirrors this same rule for offline
    demo purposes (mobile/lib/core/local_store/finance_store.dart) — this
    is the authoritative server-side implementation."""

    def __init__(
        self,
        budget_repo: BudgetRepository,
        transaction_repo: TransactionRepository,
        notification_service=None,
    ):
        self._budget_repo = budget_repo
        self._transaction_repo = transaction_repo
        self._notification_service = notification_service

    async def create_budget(self, user_id: uuid.UUID, payload: BudgetCreate) -> BudgetRead:
        if payload.period_end <= payload.period_start:
            raise ValidationError("period_end must be after period_start", field="period_end")

        budget = await self._budget_repo.create(
            user_id,
            category_id=payload.category_id,
            limit_amount=payload.limit_amount,
            period_type=payload.period_type.value,
            period_start=payload.period_start,
            period_end=payload.period_end,
            alert_thresholds=payload.alert_thresholds,
        )
        spent = await self._transaction_repo.sum_expenses_in_period(
            user_id,
            category_id=payload.category_id,
            period_start=payload.period_start,
            period_end=payload.period_end,
        )
        return self._to_read(budget, spent)

    async def get_budget(self, user_id: uuid.UUID, budget_id: uuid.UUID) -> BudgetRead:
        budget = await self._budget_repo.get(user_id, budget_id)
        if budget is None:
            raise NotFoundError("Budget not found")
        spent = await self._transaction_repo.sum_expenses_in_period(
            user_id,
            category_id=budget.category_id,
            period_start=budget.period_start,
            period_end=budget.period_end,
        )
        return self._to_read(budget, spent)

    async def list_budgets(self, user_id: uuid.UUID) -> list[BudgetRead]:
        budgets = await self._budget_repo.list_for_user(user_id)
        results = []
        for budget in budgets:
            spent = await self._transaction_repo.sum_expenses_in_period(
                user_id,
                category_id=budget.category_id,
                period_start=budget.period_start,
                period_end=budget.period_end,
            )
            results.append(self._to_read(budget, spent))
        return results

    async def recalculate_for_category(
        self, user_id: uuid.UUID, category_id: uuid.UUID | None, occurred_at: date
    ) -> None:
        """Called after a new expense transaction is written. Finds budgets
        whose period covers `occurred_at` and category matches (or is an
        overall budget), and fires a threshold notification via the
        injected notification service when a threshold is newly crossed."""
        budgets = await self._budget_repo.list_for_user(user_id)
        for budget in budgets:
            if budget.category_id is not None and budget.category_id != category_id:
                continue
            if not (budget.period_start <= occurred_at <= budget.period_end):
                continue

            spent_before = await self._transaction_repo.sum_expenses_in_period(
                user_id,
                category_id=budget.category_id,
                period_start=budget.period_start,
                period_end=occurred_at,
            )
            percent = spent_before / float(budget.limit_amount) if budget.limit_amount else 0

            if self._notification_service is not None:
                for threshold in sorted(budget.alert_thresholds):
                    if percent * 100 >= threshold:
                        await self._notification_service.notify_budget_threshold(
                            user_id, budget, threshold
                        )
                        break

    async def archive_budget(self, user_id: uuid.UUID, budget_id: uuid.UUID) -> None:
        archived = await self._budget_repo.archive(user_id, budget_id)
        if not archived:
            raise NotFoundError("Budget not found")

    @staticmethod
    def _to_read(budget, spent: float) -> BudgetRead:
        remaining = float(budget.limit_amount) - spent
        percent = spent / float(budget.limit_amount) if budget.limit_amount else 0
        return BudgetRead(
            id=budget.id,
            category_id=budget.category_id,
            limit_amount=float(budget.limit_amount),
            period_type=budget.period_type,
            period_start=budget.period_start,
            period_end=budget.period_end,
            status=budget.status,
            spent_amount=spent,
            remaining_amount=remaining,
            percent_used=percent,
            created_at=budget.created_at,
        )
