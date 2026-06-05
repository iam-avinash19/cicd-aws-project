import pytest
from main import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_home_returns_200(client):
    response = client.get('/')
    assert response.status_code == 200

def test_home_returns_json(client):
    response = client.get('/')
    data = response.get_json()
    assert data['message'] == 'CI/CD Pipeline-Auto Deployed v2!'
    assert data['author'] == 'Avinash Bagul'

def test_health_returns_200(client):
    response = client.get('/health')
    assert response.status_code == 200

def test_health_status(client):
    response = client.get('/health')
    data = response.get_json()
    assert data['status'] == 'healthy'

def test_metrics_endpoint(client):
    response = client.get('/metrics')
    assert response.status_code == 200