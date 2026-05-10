# htop

`htop` is an interactive process viewer. It extends `top` with a colour display, mouse support, scrolling, and direct process management without needing to know PIDs.

## Install

```bash
sudo apt install htop
```

## Starting

```bash
htop              # all processes, sorted by CPU
htop -u awaite    # filter to a specific user
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
| `F5` | toggle tree view (shows parent/child hierarchy) |
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
| `F1` or `h` | help |
| `Space` | tag a process (for bulk signal/kill) |
| `U` | untag all |
| `H` | toggle display of user threads |
| `K` | toggle display of kernel threads |

### Other

| Key | Action |
|-----|--------|
| `F10` or `q` | quit |
| `t` | toggle tree / flat view |

## Header meters

The top section shows CPU bars (one per core), memory, and swap. These are configurable via `F2 → Meters`. Useful additions:

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

htop is designed as an interactive tool. For scripting, prefer `ps` or `top -bn1`. However, htop can be useful in combination with recording tools:

```bash
# Capture a snapshot of the process list to a file
htop --no-color -d 1 | head -50 > snapshot.txt
```
