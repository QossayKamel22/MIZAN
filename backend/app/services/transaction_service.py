from __future__ import annotations

import uuid
from datetime import date

from app.core.errors import NotFoundError, ValidationError
from app.repositories.transaction_repository import TransactionRepository
from app.schemas.transaction import TransactionCreate, TransactionUpdate
from app.services.budget_service import BudgetService


class TransactionService:
    """Business logic for transactions (docs/FUNCTIONAL_REQUIREMENTS.md
    FR-TXN-*). Endpoints stay thin; all rules live here so they're testable
    without HTTP (docs/TESTING_STRATEGY.md §1.1)."""

    def __init__(self, repo: TransactionRepository, budget_service: BudgetService):
        self._repo = repo
        self._budget_service = budget_service

    async def create_transaction(self, user_id: uuid.UUID, payload: TransactionCreate):
        if payload.type.value == "transfer" and payload.destination_account_id is None:
            raise ValidationError(
                "destination_account_id is required for transfers", field="destination_account_id"
            )

        transaction = await self._repo.create(
            user_id,
            type=payload.type.value,
            amount=payload.amount,
            currency=payload.currency,
            category_id=payload.category_id,
            source_account_id=payload.source_account_id,
            destination_account_id=payload.destination_account_id,
            occurred_at=payload.occurred_at,
            notes=payload.notes,
            is_recurring=payload.is_recurring,
            recurrence_rule=payload.recurrence_rule,
        )

        # Mirrors docs/SYSTEM_ARCHITECTURE.md §3.1: writing an expense
        # recalculates affected budgets and may trigger a threshold
        # notification (UC-5 in docs/USE_CASES.md).
        if payload.type.value == "expense":
            await self._budget_service.recalculate_for_category(
                user_id, payload.category_id, payload.occurred_at
            )

        return transaction

    async def get_transaction(self, user_id: uuid.UUID, transaction_id: uuid.UUID):
        transaction = await self._repo.get(user_id, transaction_id)
        if transaction is None:
            raise NotFoundError("Transaction not found")
        return transaction

    async def list_transactions(
        self,
        user_id: uuid.UUID,
        *,
        type_: str | None = None,
        category_id: uuid.UUID | None = None,
        date_from: date | None = None,
        date_to: date | None = None,
        page: int = 1,
        page_size: int = 20,
    ):
        return await self._repo.list_for_user(
            user_id,
            type_=type_,
            category_id=category_id,
            date_from=date_from,
            date_to=date_to,
            page=page,
            page_size=page_size,
        )

    async def delete_transaction(self, user_id: uuid.UUID, transaction_id: uuid.UUID) -> None:
        deleted = await self._repo.delete(user_id, transaction_id)
        if not deleted:
            raise NotFoundError("Transaction not found")
