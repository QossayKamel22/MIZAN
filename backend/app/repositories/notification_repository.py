from __future__ import annotations

import uuid

from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.models import Notification


class NotificationRepository:
    def __init__(self, session: AsyncSession):
        self._session = session

    async def create(self, user_id: uuid.UUID, **fields) -> Notification:
        notification = Notification(user_id=user_id, **fields)
        self._session.add(notification)
        await self._session.flush()
        return notification

    async def list_for_user(
        self, user_id: uuid.UUID, *, page: int = 1, page_size: int = 20
    ) -> list[Notification]:
        result = await self._session.execute(
            select(Notification)
            .where(Notification.user_id == user_id)
            .order_by(Notification.created_at.desc())
            .offset((page - 1) * page_size)
            .limit(page_size)
        )
        return list(result.scalars().all())

    async def mark_read(self, user_id: uuid.UUID, notification_id: uuid.UUID) -> bool:
        result = await self._session.execute(
            update(Notification)
            .where(Notification.id == notification_id, Notification.user_id == user_id)
            .values(is_read=True)
        )
        await self._session.flush()
        return result.rowcount > 0

    async def mark_all_read(self, user_id: uuid.UUID) -> None:
        await self._session.execute(
            update(Notification).where(Notification.user_id == user_id).values(is_read=True)
        )
        await self._session.flush()
