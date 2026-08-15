from __future__ import annotations

import uuid
from datetime import date

from fastapi import APIRouter, Depends, Query

from app.api.deps import get_internal_user_id, get_transaction_service
from app.schemas.transaction import (
    PaginatedTransactions,
    TransactionCreate,
    TransactionRead,
    TransactionType,
)
from app.services.transaction_service import TransactionService

router = APIRouter()


@router.get("", response_model=PaginatedTransactions)
async def list_transactions(
    type: TransactionType | None = None,
    category_id: uuid.UUID | None = None,
    date_from: date | None = None,
    date_to: date | None = None,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: TransactionService = Depends(get_transaction_service),
):
    items, total = await service.list_transactions(
        user_id,
        type_=type.value if type else None,
        category_id=category_id,
        date_from=date_from,
        date_to=date_to,
        page=page,
        page_size=page_size,
    )
    return PaginatedTransactions(
        items=[TransactionRead.model_validate(t) for t in items],
        page=page,
        page_size=page_size,
        total=total,
    )


@router.post("", response_model=TransactionRead, status_code=201)
async def create_transaction(
    payload: TransactionCreate,
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: TransactionService = Depends(get_transaction_service),
):
    transaction = await service.create_transaction(user_id, payload)
    return TransactionRead.model_validate(transaction)


@router.get("/{transaction_id}", response_model=TransactionRead)
async def get_transaction(
    transaction_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: TransactionService = Depends(get_transaction_service),
):
    transaction = await service.get_transaction(user_id, transaction_id)
    return TransactionRead.model_validate(transaction)


@router.delete("/{transaction_id}", status_code=204)
async def delete_transaction(
    transaction_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: TransactionService = Depends(get_transaction_service),
):
    await service.delete_transaction(user_id, transaction_id)
