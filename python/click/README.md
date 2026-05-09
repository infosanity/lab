# click

`click` is a Python library for building command-line interfaces. It handles argument parsing, help text, and option types so you don't have to roll your own `argparse` boilerplate.

I reach for it whenever a script needs a flag or two — it's the smallest step up from hardcoding values that still gives you `--help` for free.

## Install

```bash
pip install click
```

Or add to your project dependencies — click is rarely installed globally.

## The pattern in practice

The pattern I use most is wrapping an existing script with a handful of options. Decorate one function, add `@click.option()` for each flag, and click handles the rest. [awssso](https://github.com/infosanity/awssso) is a good example — the whole CLI surface is one `@click.command()` with a single `--configfile` option.

```python
import click

@click.command()
@click.option('--configfile', default='app.cfg', help='Path to configuration file.')
def main(configfile):
    # your logic here
    pass

if __name__ == '__main__':
    main()
```

Running `python app.py --help` now works for free.

## Options

```python
@click.option('--name', help='Name to greet.')            # string, no default
@click.option('--config', default='app.cfg', help='...')  # string with default
@click.option('--verbose', is_flag=True, help='...')      # boolean flag
@click.option('--config', '-c', default='app.cfg', ...)   # short + long alias
@click.option('--name', prompt='Your name', help='...')   # prompt if not provided
```

The parameter name is inferred from `--option-name` automatically — don't pass it explicitly as a positional string. I managed to get this wrong in an earlier version of the skeleton; it's a subtle one.

## Subcommands (groups)

I use `@click.group()` when I need multiple subcommands under one entry point.

```python
@click.group()
@click.option('--verbose', is_flag=True)
def cli(verbose):
    pass

@cli.command()
def run():
    """Run the thing."""
    click.echo('Running.')

if __name__ == '__main__':
    cli()
```

```bash
python app.py run
python app.py --help
python app.py run --help
```

## Useful bits

- `click.echo()` is the click-idiomatic alternative to `print()` — handles encoding edge cases on Windows and piped output. In practice I use `print()` and haven't been bitten yet, but it's worth knowing about.
- `@click.command()` and `@click.group()` both accept a `name=` argument to override the inferred CLI name.
- Help text on the function docstring becomes the command's `--help` description.

## See also

- `EXAMPLE.py` in this directory — minimal working group + subcommand example
- [click documentation](https://click.palletsprojects.com/)

---

*I'll expand this as I actually use more of the library — no point documenting features I haven't touched.*
