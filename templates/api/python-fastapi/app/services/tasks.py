"""
Celery background tasks.
"""

import logging

from app.services.celery_app import celery_app

logger = logging.getLogger(__name__)


@celery_app.task
def example_task(name: str) -> str:
    """Example background task."""
    logger.info(f"Running example task with name: {name}")
    return f"Hello {name}!"


@celery_app.task
def send_email_task(email_to: str, subject: str, body: str) -> bool:
    """Send email background task."""
    logger.info(f"Sending email to {email_to} with subject: {subject}")
    # Implement your email sending logic here
    # For example, using smtplib or a service like SendGrid
    return True