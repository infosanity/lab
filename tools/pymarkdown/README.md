# pymarkdown

`pymarkdown` is a markdown linter that checks files against a set of configurable rules. Useful for catching formatting issues, broken structure, and style inconsistencies across a repo.

## Install

```bash
pipx install pymarkdownlnt
```

Note: the package name is `pymarkdownlnt` but the installed binary is `pymarkdown`.

## Basic use

```bash
pymarkdown scan file.md             # lint a single file
pymarkdown scan docs/               # lint all .md files in a directory
pymarkdown scan '**/*.md'           # lint all .md files recursively
pymarkdown scan --recurse docs/     # alternative recursive flag
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-e <rule>` | enable a specific rule |
| `-d <rule>` | disable a specific rule |
| `--config <file>` | load config from a specific file |
| `--continue-on-error` | keep scanning after first error |
| `--return-code-scheme minimal` | only non-zero on real errors (not warnings) |

## List available rules

```bash
pymarkdown plugins list
```

## Config file

pymarkdown reads `.pymarkdown.json` or a path specified with `--config`. Minimal example disabling a rule:

```json
{
  "plugins": {
    "md013": {
      "enabled": false
    }
  }
}
```

`md013` (line length) is commonly disabled for repos where long lines in code blocks are acceptable.

## Claude Code hook

To automatically lint markdown files after every Claude Code edit or write, add the following to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{"type": "command", "command": "pymarkdown scan '**/*.md' || true"}]
      }
    ]
  }
}
```

The `|| true` prevents a lint failure from blocking Claude mid-task. Remove it if you want strict enforcement that halts on any issue.
