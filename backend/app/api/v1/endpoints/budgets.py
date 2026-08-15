from __future__ import annotations

import uuid

from fastapi import APIRouter, Depends

from app.api.deps import get_budget_service, get_internal_user_id
from app.schemas.budget import BudgetCreate, BudgetRead
from app.services.budget_service import BudgetService

router = APIRouter()


@router.get("", response_model=list[BudgetRead])
async def list_budgets(
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: BudgetService = Depends(get_budget_service),
):
    return await service.list_budgets(user_id)


@router.post("", response_model=BudgetRead, status_code=201)
async def create_budget(
    payload: BudgetCreate,
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: BudgetService = Depends(get_budget_service),
):
    return await service.create_budget(user_id, payload)


@router.get("/{budget_id}", response_model=BudgetRead)
async def get_budget(
    budget_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: BudgetService = Depends(get_budget_service),
):
    return await service.get_budget(user_id, budget_id)


@router.delete("/{budget_id}", status_code=204)
async def archive_budget(
    budget_id: uuid.UUID,
    user_id: uuid.UUID = Depends(get_internal_user_id),
    service: BudgetService = Depends(get_budget_service),
):
    await service.archive_budget(user_id, budget_id)
