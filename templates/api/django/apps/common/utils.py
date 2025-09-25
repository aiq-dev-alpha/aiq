import jwt
from datetime import datetime, timedelta, timezone
from django.conf import settings


def generate_jwt_token(user_id, token_type='access'):
    """
    Generate JWT token for user authentication.
    """
    if token_type == 'access':
        expiry = datetime.now(timezone.utc) + timedelta(seconds=settings.JWT_ACCESS_TOKEN_LIFETIME)
    else:  # refresh
        expiry = datetime.now(timezone.utc) + timedelta(seconds=settings.JWT_REFRESH_TOKEN_LIFETIME)

    payload = {
        'user_id': user_id,
        'exp': expiry,
        'iat': datetime.now(timezone.utc),
        'type': token_type
    }

    return jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm='HS256')