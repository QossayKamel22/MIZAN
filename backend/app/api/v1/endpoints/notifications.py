from __future__ import annotations

import uuid

from fastapi import APIRouter, Depends, Query

from app.api.deps import get_internal_user_id, get_notification_service
from app.core.errors import NotFoundError
from app.services.notification_service import NotificationService

router = APIRouter()


@router.get("")
async def list_notifications(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: NotificationService = Depends(get_notification_service),
):
    notifications = await service.list_notifications(user_id, page, page_size)
    return [
        {
            "id": str(n.id),
            "type": n.type,
            "title": n.title,
            "body": n.body,
            "deep_link": n.deep_link,
            "is_read": n.is_read,
            "created_at": n.created_at.isoformat(),
        }
        for n in notifications
    ]


@router.post("/{notification_id}/read", status_code=204)
async def mark_read(
    notification_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: NotificationService = Depends(get_notification_service),
):
    marked = await service.mark_read(user_id, notification_id)
    if not marked:
        raise NotFoundError("Notification not found")


@router.post("/read-all", status_code=204)
async def mark_all_read(
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: NotificationService = Depends(get_notification_service),
):
    await service.mark_all_read(user_id)
