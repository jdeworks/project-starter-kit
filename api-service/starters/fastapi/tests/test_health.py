from fastapi.testclient import TestClient

from src.main import app

client = TestClient(app)


def test_health():
    res = client.get("/health")
    assert res.status_code == 200
    assert res.json() == {"status": "ok"}


def test_hello():
    res = client.get("/hello/World")
    assert res.status_code == 200
    assert res.json() == {"message": "Hello, World!"}
