"""
Database initialization utilities.
"""

import logging

from sqlalchemy.orm import Session

from app import crud, schemas
from app.core.config import settings
from app.db import base  # noqa: F401
from app.db.session import SessionLocal

logger = logging.getLogger(__name__)


def init_db() -> None:
    """Initialize database with default data."""
    db = SessionLocal()
    try:
        # Create first superuser
        user = crud.user.get_by_email(db, email=settings.FIRST_SUPERUSER_EMAIL)
        if not user:
            user_in = schemas.UserCreate(
                email=settings.FIRST_SUPERUSER_EMAIL,
                password=settings.FIRST_SUPERUSER_PASSWORD,
                is_superuser=True,
            )
            user = crud.user.create(db, obj_in=user_in)  # noqa: F841
            logger.info("First superuser created")
        else:
            logger.info("First superuser already exists")
    finally:
        db.close()