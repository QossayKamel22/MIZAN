from __future__ import annotations

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.errors import UnauthorizedError
from app.core.security import AuthenticatedUser, get_current_user
from app.db.session import get_db_session
from app.repositories.budget_repository import BudgetRepository
from app.repositories.notification_repository import NotificationRepository
from app.repositories.transaction_repository import TransactionRepository
from app.repositories.user_repository import UserRepository
from app.services.budget_service import BudgetService
from app.services.notification_service import NotificationService
from app.services.transaction_service import TransactionService


async def get_internal_user_id(
    session: AsyncSession = Depends(get_db_session),
    firebase_user: AuthenticatedUser = Depends(get_current_user),
):
    """Resolves the internal `users.id` from the verified Firebase UID —
    endpoints depend on this, never on the Firebase UID directly, keeping
    authorization scoped by the internal id used across every repository
    query (docs/SECURITY_REQUIREMENTS.md §2)."""
    repo = UserRepository(session)
    user = await repo.get_by_firebase_uid(firebase_user.firebase_uid)
    if user is None:
        raise UnauthorizedError(
            "No MIZAN profile for this account yet — call POST /auth/sync-profile first."
        )
    return user.id


def get_notification_service(
    session: AsyncSession = Depends(get_db_session),
) -> NotificationService:
    return NotificationService(NotificationRepository(session))


def get_budget_service(
    session: AsyncSession = Depends(get_db_session),
    notification_service: NotificationService = Depends(get_notification_service),
) -> BudgetService:
    return BudgetService(
        BudgetRepository(session), TransactionRepository(session), notification_service
    )


def get_transaction_service(
    session: AsyncSession = Depends(get_db_session),
    budget_service: BudgetService = Depends(get_budget_service),
) -> TransactionService:
    return TransactionService(TransactionRepository(session), budget_service)
