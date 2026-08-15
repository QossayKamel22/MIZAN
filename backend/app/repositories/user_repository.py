from __future__ import annotations

import uuid

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.models import User


class UserRepository:
    """Only layer touching the `users` ORM model directly
    (docs/TECHNICAL_ARCHITECTURE.md §2)."""

    def __init__(self, session: AsyncSession):
        self._session = session

    async def get_by_firebase_uid(self, firebase_uid: str) -> User | None:
        result = await self._session.execute(
            select(User).where(User.firebase_uid == firebase_uid, User.deleted_at.is_(None))
        )
        return result.scalar_one_or_none()

    async def get_by_id(self, user_id: uuid.UUID) -> User | None:
        result = await self._session.execute(
            select(User).where(User.id == user_id, User.deleted_at.is_(None))
        )
        return result.scalar_one_or_none()

    async def create(self, firebase_uid: str, email: str, display_name: str | None,
                      preferred_language: str = "ar") -> User:
        user = User(
            firebase_uid=firebase_uid,
            email=email,
            display_name=display_name,
            preferred_language=preferred_language,
        )
        self._session.add(user)
        await self._session.flush()
        return user

    async def soft_delete(self, user_id: uuid.UUID) -> None:
        from datetime import datetime, timezone

        user = await self.get_by_id(user_id)
        if user is not None:
            user.deleted_at = datetime.now(timezone.utc)
            await self._session.flush()
