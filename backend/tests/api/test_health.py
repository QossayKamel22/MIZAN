from fastapi.testclient import TestClient

from app.main import app


def test_health_check_returns_ok():
    client = TestClient(app)
    response = client.get("/health")
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "ok"
    assert body["app_name"] == "MIZAN"
