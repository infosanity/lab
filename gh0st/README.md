# gh0st

## BLUF
* Ubuntu
* MicroK8s

## Shell configuration

### Visual terminal indicator

When connecting to gh0st from a [byobu](../tools/byobu/README.md) session, the terminal background colour changes to red automatically and restores to black on exit. This makes it immediately obvious which panes are running on gh0st vs the local machine.

Add to `~/.bashrc` on gh0st:

```bash
printf '\033]11;#3d0000\007'
trap 'printf "\033]11;#000000\007"' EXIT
```

The `printf` sets the background using an OSC 11 escape sequence. The `trap` ensures it resets cleanly when the SSH session ends.

Requires `set -g allow-passthrough on` in `~/.tmux.conf` on the local machine — see [byobu README](../tools/byobu/README.md#colour-coding-remote-panes).

## MicroK8s

### Addons

#### Registry

