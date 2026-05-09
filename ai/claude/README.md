# Claude Code — Personal Setup

Reference for reproducing my Claude Code configuration from a vanilla install. All files map to locations under `~/.claude/`.

## File Map

```
~/.claude/
├── CLAUDE.md                    # Global instructions applied to every project
├── settings.json                # Core settings: theme, status line, hooks
├── statusline-command.sh        # Status line script (user@host:cwd (branch))
├── toneofvoice.md               # InfoSanity brand voice guide (InfoSanity repo)
├── commands/
│   └── tov-review.md            # /tov-review slash command
└── hooks/
    └── pymarkdown-check.sh      # PostToolUse hook: lints .md files on save
```

Source copies of all files (except `toneofvoice.md`) are in this directory.

---

## Setup Steps

### 1. Install dependencies

The hooks require `pymarkdown` and `jq`:

```bash
pip install pymarkdown
sudo apt install jq   # or brew install jq on macOS
```

### 2. Copy config files

```bash
# Core settings
cp settings.json ~/.claude/settings.json

# Status line script
cp statusline-command.sh ~/.claude/statusline-command.sh

# Global instructions
cp CLAUDE.md ~/.claude/CLAUDE.md

# Custom slash command
mkdir -p ~/.claude/commands
cp commands/tov-review.md ~/.claude/commands/tov-review.md

# Hook
mkdir -p ~/.claude/hooks
cp hooks/pymarkdown-check.sh ~/.claude/hooks/pymarkdown-check.sh
chmod +x ~/.claude/hooks/pymarkdown-check.sh
```

### 3. InfoSanity tone of voice guide

`tov-review.md` references `~/.claude/toneofvoice.md`. Copy this from the InfoSanity repo:

```bash
cp <infosanity-repo>/toneofvoice.md ~/.claude/toneofvoice.md
```

---

## What Each Piece Does

### `CLAUDE.md` — Global instructions

Applied at the start of every Claude Code session, regardless of project. Currently contains one rule: never fabricate CLI flags, env vars, or commands — verify against `--help`, man pages, or source before writing documentation.

### `settings.json`

- **Theme:** dark
- **Status line:** delegates to `statusline-command.sh` (see below)
- **Hook:** runs `pymarkdown-check.sh` after any `Edit` or `Write` tool call on a `.md` file

### `statusline-command.sh`

Renders a shell-prompt-style status line at the bottom of the Claude Code interface:

```
user@hostname:/current/working/dir (git-branch)
```

Branch is shown in yellow when inside a git repo; omitted otherwise. Receives a JSON blob from Claude Code on stdin; uses `jq` to extract `cwd`, then calls `git` directly for the branch.

### `hooks/pymarkdown-check.sh`

A `PostToolUse` hook triggered after `Edit` or `Write` calls. If the modified file is a `.md` file, runs `pymarkdown scan` against it and surfaces any linting output back to Claude as a `systemMessage`. This keeps markdown well-formed without manual linting.

### `commands/tov-review.md`

A custom slash command (`/tov-review <path>`) that reviews a document against the InfoSanity tone of voice guide. Produces a structured report covering: overall verdict, what's working, what needs attention, a pre-publish checklist, and a tone score across six brand personality traits.
