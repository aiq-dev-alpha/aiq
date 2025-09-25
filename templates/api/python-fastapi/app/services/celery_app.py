"""
Celery application configuration.
"""

from celery import Celery

from app.core.config import settings

celery_app = Celery("worker", broker=settings.REDIS_URL)

celery_app.conf.task_routes = {
    "app.services.tasks.*": "main-queue",
}

# Optional: Configure result backend
celery_app.conf.result_backend = settings.REDIS_URL

# Optional: Configure task serialization
celery_app.conf.task_serializer = "json"
celery_app.conf.result_serializer = "json"
celery_app.conf.accept_content = ["json"]

# Optional: Configure timezone
celery_app.conf.timezone = "UTC"
celery_app.conf.enable_utc = True