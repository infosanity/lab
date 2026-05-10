# htop

`htop` is my go-to for a quick look at what a machine is actually doing. It extends `top` with a colour display, mouse support, scrolling, and direct process management — without needing to know PIDs first.

Worth noting upfront: htop is an interactive tool. If you're writing a script, reach for `ps` or `top -bn1` instead.

Project: [htop.dev](https://htop.dev) / [github.com/htop-dev/htop](https://github.com/htop-dev/htop).

## Install

```bash
sudo apt install htop
```

## Starting

```bash
htop              # all processes, sorted by CPU
htop -u $USER     # filter to a specific user
htop -p 1234,5678 # watch specific PIDs only
htop -d 5         # set refresh interval to 0.5 s (tenths of a second)
```

## Key bindings

### Navigation

| Key | Action |
|-----|--------|
| `↑` / `↓` | move selection |
| `PgUp` / `PgDn` | scroll by page |
| `Home` / `End` | jump to top / bottom of list |

### Sorting

| Key | Action |
|-----|--------|
| `P` | sort by CPU |
| `M` | sort by memory |
| `T` | sort by time |
| `F6` or `>` | choose sort column interactively |
| `I` | invert sort order |

### Filtering and searching

| Key | Action |
|-----|--------|
| `F3` or `/` | search process name |
| `F4` or `\` | filter — hide non-matching processes |
| `u` | filter by user |

### Process management

| Key | Action |
|-----|--------|
| `F9` or `k` | send signal to selected process |
| `F7` / `F8` | decrease / increase nice value (priority) |
| `e` | show environment variables for process |
| `l` | show open files (`lsof`) for process |
| `s` | trace system calls (`strace`) for process |

### Display

| Key | Action |
|-----|--------|
| `F2` | setup — configure meters, columns, colours |
| `F5` or `t` | toggle tree view (shows parent/child hierarchy) |
| `F1` or `h` | help |
| `Space` | tag a process (for bulk signal/kill) |
| `U` | untag all |
| `H` | toggle display of user threads |
| `K` | toggle display of kernel threads |
| `F10` or `q` | quit |

## Header meters

The top section shows CPU bars (one per core), memory, and swap. These are configurable via `F2 → Meters` — it's worth spending a few minutes in there. Useful additions:

- **Load average** — 1/5/15 minute averages
- **Uptime**
- **Hostname** — useful when SSHing between machines

## Useful flags

| Flag | Effect |
|------|--------|
| `-u <user>` | show only processes owned by user |
| `-p <pid,...>` | watch a specific set of PIDs |
| `-d <tenths>` | refresh interval in tenths of a second |
| `--no-color` | disable colour (useful over degraded terminals) |
| `-C` | same as `--no-color` |

## Non-interactive use

htop isn't designed for scripting — for that, use `ps` or `top -bn1`. That said, `--no-color` makes the output at least parseable if you're capturing it for logging purposes. I wouldn't rely on the format being stable.

```bash
htop --no-color -d 1 | head -50 > snapshot.txt
```
