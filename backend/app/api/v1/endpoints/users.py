from __future__ import annotations

import uuid

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import AuthenticatedUser, get_current_user
from app.db.session import get_db_session
from app.repositories.user_repository import UserRepository

router = APIRouter()


@router.post("/auth/sync-profile", status_code=201)
async def sync_profile(
    display_name: str | None = None,
    preferred_language: str = "ar",
    firebase_user: AuthenticatedUser = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    """Creates the internal `users` row after first Firebase sign-in
    (docs/API_SPECIFICATION.md §2). Idempotent — returns the existing
    profile if one already exists for this Firebase UID."""
    repo = UserRepository(session)
    existing = await repo.get_by_firebase_uid(firebase_user.firebase_uid)
    if existing is not None:
        await session.commit()
        return {"id": str(existing.id), "email": existing.email}

    user = await repo.create(
        firebase_uid=firebase_user.firebase_uid,
        email=firebase_user.email or "",
        display_name=display_name,
        preferred_language=preferred_language,
    )
    await session.commit()
    return {"id": str(user.id), "email": user.email}


@router.get("/users/me")
async def get_me(
    firebase_user: AuthenticatedUser = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    repo = UserRepository(session)
    user = await repo.get_by_firebase_uid(firebase_user.firebase_uid)
    if user is None:
        return {"detail": "No profile yet. Call POST /auth/sync-profile."}
    return {
        "id": str(user.id),
        "email": user.email,
        "display_name": user.display_name,
        "preferred_language": user.preferred_language,
        "base_currency": user.base_currency,
    }


@router.delete("/users/me", status_code=204)
async def delete_me(
    firebase_user: AuthenticatedUser = Depends(get_current_user),
    session: AsyncSession = Depends(get_db_session),
):
    """Soft-deletes the account (docs/SECURITY_REQUIREMENTS.md §8) — a hard
    purge job (pending infra, see docs/DEPLOYMENT_PLAN.md) removes rows
    after the retention window."""
    repo = UserRepository(session)
    user = await repo.get_by_firebase_uid(firebase_user.firebase_uid)
    if user is not None:
        await repo.soft_delete(user.id)
        await session.commit()
