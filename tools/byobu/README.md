# byobu

`byobu` is a terminal multiplexer layer that sits on top of `tmux`. It adds a status bar and maps common operations to function keys, so you get the power of tmux with a lower barrier to entry.

## Install

```bash
sudo apt install byobu
```

## Starting a session

```bash
byobu             # attach to existing session or start a new one
byobu new -s work # start a named session
byobu ls          # list sessions
byobu attach -t work
```

## Function key bindings

These are the byobu-specific keys that work out of the box:

| Key | Action |
|-----|--------|
| `F2` | new window |
| `F3` | previous window |
| `F4` | next window |
| `F6` | detach from all sessions and logout |
| `Shift+F6` | detach from current session only (session keeps running, returns to parent shell) |
| `F7` | enter scrollback / copy mode |
| `F8` | rename current window |
| `Shift+F2` | split pane horizontally |
| `Ctrl+F2` | split pane vertically |
| `Shift+F3` / `Shift+F4` | move between panes |

## tmux passthrough

All standard tmux key bindings work using the tmux prefix (`Ctrl+b` by default). Byobu also supports changing the prefix to `Ctrl+a` (screen-style):

```bash
byobu-ctrl-a    # toggle between Ctrl+a and Ctrl+b as prefix
```

## Status bar

The bottom bar shows system stats (load, memory, network, time). Toggle individual segments:

```bash
byobu-config    # interactive menu for status notifications
```

## Enable byobu on login

```bash
byobu-enable         # auto-attach to byobu on every SSH/terminal login
byobu-disable        # revert to plain shell on login
```

## Scrollback / copy mode

`F7` enters copy mode. Navigate with arrow keys or `j`/`k`, `Space` to start selection, `Enter` to copy. Exit with `q`.

## Session persistence

Sessions survive disconnection. After reconnecting:

```bash
byobu attach       # or just: byobu
```
