from __future__ import annotations

import uuid
from datetime import date

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.models import Transaction


class TransactionRepository:
    def __init__(self, session: AsyncSession):
        self._session = session

    async def create(self, user_id: uuid.UUID, **fields) -> Transaction:
        transaction = Transaction(user_id=user_id, **fields)
        self._session.add(transaction)
        await self._session.flush()
        return transaction

    async def get(self, user_id: uuid.UUID, transaction_id: uuid.UUID) -> Transaction | None:
        result = await self._session.execute(
            select(Transaction).where(
                Transaction.id == transaction_id, Transaction.user_id == user_id
            )
        )
        return result.scalar_one_or_none()

    async def list_for_user(
        self,
        user_id: uuid.UUID,
        *,
        type_: str | None = None,
        category_id: uuid.UUID | None = None,
        date_from: date | None = None,
        date_to: date | None = None,
        page: int = 1,
        page_size: int = 20,
    ) -> tuple[list[Transaction], int]:
        query = select(Transaction).where(Transaction.user_id == user_id)
        if type_:
            query = query.where(Transaction.type == type_)
        if category_id:
            query = query.where(Transaction.category_id == category_id)
        if date_from:
            query = query.where(Transaction.occurred_at >= date_from)
        if date_to:
            query = query.where(Transaction.occurred_at <= date_to)

        count_query = select(func.count()).select_from(query.subquery())
        total = (await self._session.execute(count_query)).scalar_one()

        query = (
            query.order_by(Transaction.occurred_at.desc())
            .offset((page - 1) * page_size)
            .limit(page_size)
        )
        items = (await self._session.execute(query)).scalars().all()
        return list(items), total

    async def sum_expenses_in_period(
        self,
        user_id: uuid.UUID,
        *,
        category_id: uuid.UUID | None,
        period_start: date,
        period_end: date,
    ) -> float:
        query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            Transaction.user_id == user_id,
            Transaction.type == "expense",
            Transaction.occurred_at >= period_start,
            Transaction.occurred_at <= period_end,
        )
        if category_id is not None:
            query = query.where(Transaction.category_id == category_id)
        result = await self._session.execute(query)
        return float(result.scalar_one())

    async def delete(self, user_id: uuid.UUID, transaction_id: uuid.UUID) -> bool:
        transaction = await self.get(user_id, transaction_id)
        if transaction is None:
            return False
        await self._session.delete(transaction)
        await self._session.flush()
        return True
