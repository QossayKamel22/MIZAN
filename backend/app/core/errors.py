from __future__ import annotations

from fastapi import Request, status
from fastapi.responses import JSONResponse


class DomainError(Exception):
    """Base class for domain-specific errors raised by services/repositories.
    Mapped to the standardized error envelope (docs/API_SPECIFICATION.md §10)
    by the global exception handlers registered below — endpoints never
    construct error responses manually."""

    status_code: int = status.HTTP_400_BAD_REQUEST
    code: str = "ERROR"

    def __init__(self, message: str, field: str | None = None):
        self.message = message
        self.field = field
        super().__init__(message)


class ValidationError(DomainError):
    status_code = status.HTTP_400_BAD_REQUEST
    code = "VALIDATION_ERROR"


class NotFoundError(DomainError):
    status_code = status.HTTP_404_NOT_FOUND
    code = "NOT_FOUND"


class UnauthorizedError(DomainError):
    status_code = status.HTTP_401_UNAUTHORIZED
    code = "UNAUTHORIZED"


class ForbiddenError(DomainError):
    status_code = status.HTTP_403_FORBIDDEN
    code = "FORBIDDEN"


class ConflictError(DomainError):
    status_code = status.HTTP_409_CONFLICT
    code = "CONFLICT"


class RateLimitedError(DomainError):
    status_code = status.HTTP_429_TOO_MANY_REQUESTS
    code = "RATE_LIMITED"


def _error_envelope(code: str, message: str, field: str | None = None) -> dict:
    body: dict = {"error": {"code": code, "message": message}}
    if field:
        body["error"]["field"] = field
    return body


async def domain_error_handler(request: Request, exc: DomainError) -> JSONResponse:
    return JSONResponse(
        status_code=exc.status_code,
        content=_error_envelope(exc.code, exc.message, exc.field),
    )


async def unhandled_error_handler(request: Request, exc: Exception) -> JSONResponse:
    # Never leak internals in the response (docs/SECURITY_REQUIREMENTS.md §9).
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content=_error_envelope("INTERNAL_ERROR", "Something went wrong. Please try again."),
    )
