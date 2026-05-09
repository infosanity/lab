# black

`black` is an opinionated Python code formatter. It enforces a consistent style by reformatting code in place, leaving no decisions to the developer.

## Install

```bash
pipx install black
```

## Basic use

```bash
black file.py               # format a file in place
black src/                  # format all .py files in a directory recursively
black --check file.py       # check without writing — exits non-zero if changes would be made
black --diff file.py        # show diff of what would change, without writing
cat file.py | black -       # format from stdin, output to stdout
```

## Useful flags

| Flag | Effect |
|------|--------|
| `--check` | report files that would be reformatted; no writes |
| `--diff` | show unified diff of changes; no writes |
| `-l <n>` / `--line-length <n>` | override default line length of 88 |
| `--quiet` | suppress all output except errors |
| `--target-version` | specify minimum Python version(s) e.g. `--target-version py311` |

## Config (pyproject.toml)

Black reads configuration from `pyproject.toml` if present at the project root:

```toml
[tool.black]
line-length = 88
target-version = ["py311"]
exclude = '''
/(
    \.venv
  | build
  | dist
)/
'''
```

## VS Code integration

Install the [Black Formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter) extension (publisher: `ms-python`).

Add to `.vscode/settings.json` in the project, or user `settings.json` for global effect:

```json
{
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true
  }
}
```

The extension uses the `black` binary from the active Python environment — if installed via pipx, point it at the pipx venv explicitly to avoid version mismatches:

```json
{
  "black-formatter.path": ["~/.local/share/pipx/venvs/black/bin/black"]
}
```

Any `pyproject.toml` config in the project root is picked up automatically — no separate VS Code config needed for line length or excludes.

## Pipeline use

Check formatting as part of a script without modifying files:

```bash
black --check --quiet src/ && echo "formatting ok" || echo "reformat needed"
```

## Checking a single changed file

```bash
git diff --name-only | grep '\.py$' | xargs black --check
```
