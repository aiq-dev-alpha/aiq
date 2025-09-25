from django.db import models
from django.conf import settings
from apps.common.models import TimeStampedModel


class Post(TimeStampedModel):
    """
    Post model for user-generated content.
    """
    title = models.CharField(max_length=255)
    content = models.TextField()
    author = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='posts'
    )

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return self.title