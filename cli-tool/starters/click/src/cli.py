import click

from .logic import greet_message, count_sequence


@click.group()
@click.version_option(version="1.0.0")
def main() -> None:
    """A simple CLI tool built with Click."""


@main.command()
@click.argument("name")
def greet(name: str) -> None:
    """Greet someone by name."""
    click.echo(greet_message(name))


@main.command()
@click.argument("n", type=int)
def count(n: int) -> None:
    """Count from 1 to n."""
    if n < 1:
        raise click.BadParameter("n must be a positive integer")
    for i in count_sequence(n):
        click.echo(i)
