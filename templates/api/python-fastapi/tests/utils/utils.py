"""
Utility functions for tests.
"""

import random
import string


def random_lower_string() -> str:
    """Generate random lowercase string."""
    return "".join(random.choices(string.ascii_lowercase, k=32))


def random_email() -> str:
    """Generate random email address."""
    return f"{random_lower_string()}@{random_lower_string()}.com"