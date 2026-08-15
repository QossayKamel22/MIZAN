from __future__ import annotations

import uuid

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.models import Budget


class BudgetRepository:
    def __init__(self, session: AsyncSession):
        self._session = session

    async def create(self, user_id: uuid.UUID, **fields) -> Budget:
        budget = Budget(user_id=user_id, **fields)
        self._session.add(budget)
        await self._session.flush()
        return budget

    async def get(self, user_id: uuid.UUID, budget_id: uuid.UUID) -> Budget | None:
        result = await self._session.execute(
            select(Budget).where(Budget.id == budget_id, Budget.user_id == user_id)
        )
        return result.scalar_one_or_none()

    async def list_for_user(self, user_id: uuid.UUID, *, status: str = "active") -> list[Budget]:
        result = await self._session.execute(
            select(Budget).where(Budget.user_id == user_id, Budget.status == status)
        )
        return list(result.scalars().all())

    async def archive(self, user_id: uuid.UUID, budget_id: uuid.UUID) -> bool:
        budget = await self.get(user_id, budget_id)
        if budget is None:
            return False
        budget.status = "archived"
        await self._session.flush()
        return True
