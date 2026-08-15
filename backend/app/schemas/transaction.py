from __future__ import annotations

import uuid
from datetime import date, datetime
from enum import Enum

from pydantic import BaseModel, Field, field_validator


class TransactionType(str, Enum):
    income = "income"
    expense = "expense"
    transfer = "transfer"
    savings_contribution = "savings_contribution"


class TransactionCreate(BaseModel):
    type: TransactionType
    amount: float = Field(gt=0, description="Always positive; sign implied by type")
    currency: str = "AED"
    category_id: uuid.UUID | None = None
    source_account_id: uuid.UUID | None = None
    destination_account_id: uuid.UUID | None = None
    occurred_at: date
    notes: str | None = None
    is_recurring: bool = False
    recurrence_rule: str | None = None

    @field_validator("destination_account_id")
    @classmethod
    def transfer_requires_destination(cls, v, info):
        if info.data.get("type") == TransactionType.transfer and v is None:
            raise ValueError("destination_account_id is required for transfers")
        return v


class TransactionUpdate(BaseModel):
    amount: float | None = Field(default=None, gt=0)
    category_id: uuid.UUID | None = None
    occurred_at: date | None = None
    notes: str | None = None


class TransactionRead(BaseModel):
    id: uuid.UUID
    type: TransactionType
    amount: float
    currency: str
    category_id: uuid.UUID | None
    source_account_id: uuid.UUID | None
    destination_account_id: uuid.UUID | None
    occurred_at: date
    notes: str | None
    is_recurring: bool
    created_at: datetime

    model_config = {"from_attributes": True}


class PaginatedTransactions(BaseModel):
    items: list[TransactionRead]
    page: int
    page_size: int
    total: int
