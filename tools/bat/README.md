# bat

`bat` is a `cat` replacement with syntax highlighting, line numbers, git change markers, and automatic paging.

## Install

```bash
sudo apt install bat
```

On Ubuntu/Debian the binary is installed as `batcat` to avoid a name conflict. Add an alias:

```bash
# ~/.bash_aliases
alias bat='batcat'
```

## Basic use

```bash
bat file.py               # syntax-highlighted output with line numbers
bat file1.py file2.py     # concatenate multiple files
bat -n file.py            # line numbers only, no other decorations
bat -p file.py            # plain — no line numbers, no pager, no decorations
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-p` / `--plain` | raw output, no decorations (useful in scripts) |
| `-l <lang>` | force language (e.g. `-l json`, `-l bash`) |
| `--theme=<name>` | override colour theme |
| `-r <N:M>` | print only lines N through M |
| `--diff` | only show lines with git changes and their context |
| `-A` | show non-printable characters |

## Use in pipelines

`bat` auto-detects when stdout is not a terminal and disables decorations, so it's safe to use in pipes without `-p`:

```bash
curl -s https://api.example.com/data | bat -l json
some-command 2>&1 | bat -l log
```

## Themes

```bash
bat --list-themes          # list available themes
bat --theme=TwoDark file   # preview a theme
```

Set a default in `~/.config/bat/config`:

```
--theme=TwoDark
```

## Manpage integration

```bash
# Pretty-print man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```
