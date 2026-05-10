# screen

GNU `screen` is a terminal multiplexer — it lets you run multiple terminal sessions inside a single connection and detach/reattach them at will. Sessions survive disconnection, which makes it invaluable for long-running processes over SSH.

Worth saying upfront: if you're on a machine where you can install what you like, [byobu](../byobu/README.md) is a friendlier option built on top of tmux. `screen`'s value is that it's already there on minimal servers where you can't install anything. That's the main reason I keep notes on it.

Project homepage: [savannah.gnu.org/projects/screen](https://savannah.gnu.org/projects/screen).

## Install

```bash
sudo apt install screen
```

## Starting a session

```bash
screen              # start a new unnamed session
screen -dR          # "Get me back where I was"-mode - reattach to previous session
screen -S work      # start a named session
screen -ls          # list all sessions
screen -r work      # reattach to a named session
screen -r           # reattach if only one session exists
screen -x           # attach to a session without detaching others (multi-display)
```

## Key bindings

All commands use the prefix `Ctrl+a`. Press the prefix, release, then press the binding key.

| Keys | Action |
|------|--------|
| `Ctrl+a c` | create new window |
| `Ctrl+a n` | next window |
| `Ctrl+a p` | previous window |
| `Ctrl+a w` | list all windows |
| `Ctrl+a d` | detach (session keeps running) |
| `Ctrl+a [` | enter scrollback / copy mode |
| `Ctrl+a ]` | paste from copy buffer |
| `Ctrl+a :` | enter command mode |
| `Ctrl+a ?` | show key binding help |

In copy mode, navigate with arrow keys, `Space` to mark start of selection, `Space` again to copy. Exit with `Escape` or `q`.

## Useful flags

| Flag | Effect |
|------|--------|
| `-S name` | name the session on creation |
| `-r [name]` | reattach to a detached session |
| `-x` | attach to an already-attached session (shared display) |
| `-ls` | list sessions |
| `-d [name]` | detach a running session without attaching |
| `-D [name]` | detach and logout the remote user |
| `-R` | reattach if possible, otherwise create new session |
| `-c file` | use an alternative config file instead of `~/.screenrc` |
| `-h N` | set scrollback buffer size to N lines |
| `-U` | run in UTF-8 mode |
| `-X cmd` | send a command to a running session |
| `-wipe` | like `-ls` but removes dead session entries |

## Configuration

`~/.screenrc` is loaded on startup. The first thing I add is `startup_message off` — screen's default welcome screen is not the warm greeting it thinks it is. Left enabled, it at least gets piped through cowsay.

```
# Disable the startup message
startup_message off

# Larger scrollback buffer
defscrollback 5000

# Show window list in status bar
hardstatus alwayslastline "%w"
```

## Session persistence

Detach with `Ctrl+a d` and the session keeps running. Reattach later:

```bash
screen -r           # reattach (works if only one session)
screen -ls          # find session name/PID if multiple exist
screen -r work      # reattach by name
```

## Auto-attach on SSH login

My primary use case for screen is providing some session stability when remoting into a server. Network stability may have improved from the days of listening to dial-tones and modem handshakes, but old habits die hard.
If you find yourself repeatedly forgetting to start a screen session before getting stuck into work — or just want the recovery pattern there by default — this is a common find in most `~/.bashrc` on any remote machine I'm responsible for:

```bash
if [[ -z "$STY" && -n "$SSH_CONNECTION" ]]; then
    screen -dR
fi
```

`$STY` is set whenever you're inside a screen session, so the guard prevents screen from launching inside itself. `$SSH_CONNECTION` limits it to SSH logins — local terminals are unaffected. `screen -dR` reattaches to an existing session (detaching any other connection to it first), or creates a new one if none exists.

## Sending a command to a running session

Useful for scripting or when you want to kick off something in a detached session without attaching to it:

```bash
screen -S work -X stuff "ls -la\n"
```
