"""
Message schemas for API responses.
"""

from pydantic import BaseModel


class Msg(BaseModel):
    msg: str