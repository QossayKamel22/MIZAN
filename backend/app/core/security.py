from __future__ import annotations

from dataclasses import dataclass

from fastapi import Depends, Header

from app.core.config import Settings, get_settings
from app.core.errors import UnauthorizedError

try:
    import firebase_admin
    from firebase_admin import auth as firebase_auth
    from firebase_admin import credentials
except ImportError:  # pragma: no cover - firebase_admin optional at import time
    firebase_admin = None  # type: ignore
    firebase_auth = None  # type: ignore
    credentials = None  # type: ignore

_firebase_app = None


@dataclass
class AuthenticatedUser:
    """Resolved from a verified Firebase ID token. `firebase_uid` is the
    stable external identity; `user_id` is resolved by the caller (service
    layer) from the internal `users` table (docs/DATABASE_DESIGN.md §3.1)."""

    firebase_uid: str
    email: str | None


def _get_firebase_app(settings: Settings):
    global _firebase_app
    if not settings.firebase_configured:
        return None
    if _firebase_app is None and firebase_admin is not None:
        cred = credentials.Certificate(
            {
                "type": "service_account",
                "project_id": settings.firebase_project_id,
                "private_key_id": settings.firebase_private_key_id,
                "private_key": settings.firebase_private_key.replace("\\n", "\n"),
                "client_email": settings.firebase_client_email,
                "client_id": settings.firebase_client_id,
                "token_uri": "https://oauth2.googleapis.com/token",
            }
        )
        _firebase_app = firebase_admin.initialize_app(cred)
    return _firebase_app


async def get_current_user(
    authorization: str | None = Header(default=None),
    settings: Settings = Depends(get_settings),
) -> AuthenticatedUser:
    """Verifies the Firebase ID token on every authenticated request
    (docs/SECURITY_REQUIREMENTS.md §1) — never trusts a client-supplied
    user id.

    PENDING: without a provisioned Firebase project (settings.firebase_configured
    is False), token verification cannot run against a real identity
    provider. This is documented, not silently bypassed: in that state the
    dependency raises UnauthorizedError rather than fabricating a user,
    except in explicit test fixtures which monkeypatch this dependency
    (see backend/tests/api/conftest.py).
    """
    if authorization is None or not authorization.startswith("Bearer "):
        raise UnauthorizedError("Missing or malformed Authorization header")

    token = authorization.removeprefix("Bearer ").strip()

    app = _get_firebase_app(settings)
    if app is None or firebase_auth is None:
        raise UnauthorizedError(
            "Firebase is not configured in this environment (pending project "
            "provisioning — see docs/DEPLOYMENT_PLAN.md §3)."
        )

    try:
        decoded = firebase_auth.verify_id_token(token, app=app)
    except Exception as exc:  # noqa: BLE001 - firebase raises various error types
        raise UnauthorizedError("Invalid or expired token") from exc

    return AuthenticatedUser(
        firebase_uid=decoded["uid"],
        email=decoded.get("email"),
    )
