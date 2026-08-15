from __future__ import annotations

import uuid
from datetime import date, datetime
from enum import Enum

from pydantic import BaseModel, Field


class BudgetPeriod(str, Enum):
    weekly = "weekly"
    monthly = "monthly"
    custom = "custom"


class BudgetCreate(BaseModel):
    category_id: uuid.UUID | None = None
    limit_amount: float = Field(gt=0)
    period_type: BudgetPeriod
    period_start: date
    period_end: date
    alert_thresholds: list[int] = [80, 100]


class BudgetRead(BaseModel):
    id: uuid.UUID
    category_id: uuid.UUID | None
    limit_amount: float
    period_type: BudgetPeriod
    period_start: date
    period_end: date
    status: str
    spent_amount: float
    remaining_amount: float
    percent_used: float
    created_at: datetime

    model_config = {"from_attributes": True}
