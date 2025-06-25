from fastapi.testclient import TestClient
from main import app 

client = TestClient(app)

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "healthy"
    assert "timestamp" in body

def test_get_items():
    response = client.get("/items")
    assert response.status_code == 200
    body = response.json()
    assert "items" in body
    assert isinstance(body["items"], list)

def test_create_item():
    payload = {
        "name": "Test Product",
        "price": 99.99,
        "description": "A sample product"
    }
    response = client.post("/items", json=payload)
    assert response.status_code == 200
    body = response.json()
    assert body["message"] == "Item created"
    assert body["item"] == payload
