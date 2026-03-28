"""Pure functions for CLI commands."""


def greet_message(name: str) -> str:
    """Build a greeting message."""
    return f"Hello, {name}!"


def count_sequence(n: int) -> list[int]:
    """Generate a count sequence from 1 to n."""
    return list(range(1, n + 1))
