import click

@click.group()
@click.option('--verbose', is_flag=True, help="Enable verbose output.", default=False, required=False)   
def cli(verbose = False):
    """A simple CLI application using Click."""
    pass

@cli.command()
def function():
    """A simple command that prints a message."""
    click.echo("Function executed!")

@cli.command()
@click.option('--name', prompt="Your name", help="The name to greet.")
def greet(name):
    """Greet the user by name."""
    click.echo(f"Hello, {name}!")

if __name__ == "__main__":
    cli()