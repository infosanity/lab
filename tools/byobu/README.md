# byobu

`byobu` is a terminal multiplexer layer that sits on top of `tmux`. It adds a status bar and maps common operations to function keys, so you get the power of tmux with a lower barrier to entry. I use it over raw tmux because, well, even has a long time cli shell-monkey tmux never clicked (yes, I use nano over vi....) key bindings and status bar come pre-wired — less config to confuse, more time actually doing things.

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

## Prompt customisation

One thing that catches people out: byobu sets its own `PS1`, silently overriding whatever you've configured in `~/.bashrc`. Any git branch indicators or custom prompt tweaks you added there will simply disappear when byobu starts; don't ask how long I spent debugging that one.....

The fix is `~/.config/byobu/prompt` — this file is sourced *after* the system byobu profile, so anything set here wins.

To add a git branch indicator (yellow, shown only inside a git repo), I slot a `byobu_git_branch` function just before `byobu_prompt_symbol` so the branch appears right before `$`:

> **Note:** The PS1 below uses Ubuntu colours — byobu's default on Ubuntu (`$BYOBU_DISTRO=Ubuntu`). If you're on a different distro, check `echo $BYOBU_DISTRO` and adjust the colour codes to match your byobu profile.

```bash
# ~/.config/byobu/prompt
[ -r /usr/share/byobu/profiles/bashrc ] && . /usr/share/byobu/profiles/bashrc  #byobu-prompt#

byobu_git_branch() {
    local b=$(git branch --show-current 2>/dev/null)
    [ -n "$b" ] && printf " \e[38;5;226m(%s)\e[00m" "$b"
}

export PS1="${debian_chroot:+($debian_chroot)}\[\e[38;5;202m\]\$(byobu_prompt_status)\[\e[00m\]\$(byobu_prompt_runtime) \[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;172m\]\h\[\e[00m\]:\[\e[38;5;5m\]\w\[\e[00m\]\$(byobu_git_branch)\$(byobu_prompt_symbol) "
```

Reload without opening a new window:

```bash
source ~/.config/byobu/prompt
```

## Colour-coding remote panes

When SSHing into a remote machine from within a byobu pane, the terminal background colour can be changed automatically on connect and restored on disconnect. This gives an immediate visual indicator of which pane is running on which machine.

Requires passthrough enabled in `~/.tmux.conf` so OSC escape sequences reach the terminal:

```
set -g allow-passthrough on
```

See [gh0st README](../../gh0st/README.md#visual-terminal-indicator) for the remote-side configuration.
