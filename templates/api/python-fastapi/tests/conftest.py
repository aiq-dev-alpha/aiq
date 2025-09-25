"""
Pytest configuration and fixtures.
"""

from typing import Dict, Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app import crud
from app.core.config import settings
from app.db.session import SessionLocal
from main import app
from app.core.deps import get_db
from app import schemas

# Test database
engine = create_engine(settings.TEST_DATABASE_URL or settings.DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def override_get_db():
    """Override database dependency for tests."""
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db


@pytest.fixture(scope="session")
def db() -> Generator:
    """Database fixture."""
    yield TestingSessionLocal()


@pytest.fixture(scope="module")
def client() -> Generator:
    """Test client fixture."""
    with TestClient(app) as c:
        yield c


@pytest.fixture(scope="module")
def superuser_token_headers(client: TestClient) -> Dict[str, str]:
    """Get superuser authentication headers."""
    login_data = {
        "username": settings.FIRST_SUPERUSER_EMAIL,
        "password": settings.FIRST_SUPERUSER_PASSWORD,
    }
    r = client.post(f"{settings.API_V1_STR}/login/access-token", data=login_data)
    tokens = r.json()
    a_token = tokens["access_token"]
    headers = {"Authorization": f"Bearer {a_token}"}
    return headers


@pytest.fixture(scope="module")
def normal_user_token_headers(client: TestClient, db: SessionLocal) -> Dict[str, str]:
    """Get normal user authentication headers."""
    # Create normal user
    user_data = {
        "email": "test@example.com",
        "password": "testpassword",
        "full_name": "Test User"
    }
    user_in = schemas.UserCreate(**user_data)
    user = crud.user.create(db, obj_in=user_in)

    # Login to get token
    login_data = {
        "username": user_data["email"],
        "password": user_data["password"],
    }
    r = client.post(f"{settings.API_V1_STR}/login/access-token", data=login_data)
    tokens = r.json()
    a_token = tokens["access_token"]
    headers = {"Authorization": f"Bearer {a_token}"}
    return headers