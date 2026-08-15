from fastapi import APIRouter

from app.api.v1.endpoints import ai, budgets, notifications, transactions, users

api_router = APIRouter(prefix="/api/v1")
api_router.include_router(users.router, tags=["users"])
api_router.include_router(transactions.router, prefix="/transactions", tags=["transactions"])
api_router.include_router(budgets.router, prefix="/budgets", tags=["budgets"])
api_router.include_router(notifications.router, prefix="/notifications", tags=["notifications"])
api_router.include_router(ai.router, prefix="/ai", tags=["ai"])
