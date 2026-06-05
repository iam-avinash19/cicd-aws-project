import pytest
import sys
import os

sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

import importlib.util
spec = importlib.util.spec_from_file_location("flask_app", os.path.join(os.path.dirname(__file__), "app.py"))
flask_app_module = importlib.util.load_from_spec(spec)
spec.loader.exec_module(flask_app_module)

flask_app = flask_app_module.app

@pytest.fixture
def client():
    flask_app.config['TESTING'] = True
    with flask_app.test_client() as client:
        yield client

def test_home_returns_200(client):
    response = client.get('/')
    assert response.status_code == 200

def test_home_returns_json(client):
    response = client.get('/')
    data = response.get_json()
    assert data['message'] == 'CI/CD Pipeline is working!'
    assert data['author'] == 'Avinash Bagul'

def test_health_returns_200(client):
    response = client.get('/health')
    assert response.status_code == 200

def test_health_status(client):
    response = client.get('/health')
    data = response.get_json()
    assert data['status'] == 'healthy'