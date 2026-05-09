# glow

`glow` renders markdown in the terminal with styled output. Useful for reading READMEs and notes without leaving the shell.

## Install

```bash
snap install glow
```

## Basic use

```bash
glow README.md            # render a file
glow .                    # browse all markdown files in current directory
glow -p README.md         # pager mode (scroll with arrow keys / j/k, q to quit)
```

## Reading from stdin

```bash
cat README.md | glow -
curl -s https://raw.githubusercontent.com/.../README.md | glow -
```

## Pager mode

`-p` opens an interactive pager — useful for long documents:

```bash
glow -p somefile.md
```

Key bindings inside the pager mirror `less`: arrow keys or `j`/`k` to scroll, `q` to quit, `/` to search.

## Stash

`glow` has a local stash for saving and retrieving markdown snippets:

```bash
glow stash push README.md          # add to stash
glow stash                         # browse stashed items
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-p` | open in pager |
| `-w <width>` | word-wrap width (default 80) |
| `-s <style>` | colour style: `dark`, `light`, `notty`, `dracula`, `tokyo-night` |
