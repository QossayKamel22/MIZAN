from __future__ import annotations

import uuid

from app.repositories.notification_repository import NotificationRepository


class NotificationService:
    """Creates notification records for bill reminders, budget alerts, AI
    insights, and goal milestones (docs/FUNCTIONAL_REQUIREMENTS.md
    FR-NOTIF-1). Also responsible for mirroring to Firestore for real-time
    delivery (docs/DATABASE_DESIGN.md §1) — that mirror call is a pending
    integration point requiring a provisioned Firebase project (see
    docs/FINAL_TECHNICAL_REPORT.md); the Postgres write below is real and
    functions independently of that pending piece."""

    def __init__(self, repo: NotificationRepository, firestore_client=None):
        self._repo = repo
        self._firestore_client = firestore_client

    async def notify_budget_threshold(self, user_id: uuid.UUID, budget, threshold: int) -> None:
        title = "Budget limit reached" if threshold >= 100 else f"Budget at {threshold}%"
        body = (
            f"Your budget has reached its limit."
            if threshold >= 100
            else f"Your budget has reached {threshold}% of its limit."
        )
        notification = await self._repo.create(
            user_id,
            type="budget_alert",
            title=title,
            body=body,
            deep_link=f"/budget/{budget.id}",
        )
        await self._mirror_to_firestore(user_id, notification)

    async def notify_bill_due(self, user_id: uuid.UUID, bill) -> None:
        notification = await self._repo.create(
            user_id,
            type="bill_reminder",
            title="Upcoming bill",
            body=f"{bill.payee_name} of {bill.amount} is due on {bill.due_date}.",
            deep_link=f"/bills/{bill.id}",
        )
        await self._mirror_to_firestore(user_id, notification)

    async def list_notifications(self, user_id: uuid.UUID, page: int = 1, page_size: int = 20):
        return await self._repo.list_for_user(user_id, page=page, page_size=page_size)

    async def mark_read(self, user_id: uuid.UUID, notification_id: uuid.UUID) -> bool:
        return await self._repo.mark_read(user_id, notification_id)

    async def mark_all_read(self, user_id: uuid.UUID) -> None:
        await self._repo.mark_all_read(user_id)

    async def _mirror_to_firestore(self, user_id: uuid.UUID, notification) -> None:
        if self._firestore_client is None:
            return  # pending Firebase provisioning; Postgres remains source of truth
        # PENDING: real Firestore write, e.g.:
        # self._firestore_client.collection("users").document(str(user_id)) \
        #     .collection("notifications").document(str(notification.id)).set({...})
