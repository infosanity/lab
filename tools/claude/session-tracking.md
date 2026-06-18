# claude session tracking

A small Claude Code setup that logs which sessions I've worked on — capturing a timestamp, the **human session name** (the title I set, not the UUID) and the working directory. It exists because I kept losing track of which session a given piece of work happened in across multiple parallel sessions and repos.

It's three parts: a hook script, a `hooks` block in `~/.claude/settings.json`, and a shell reader function.

## How it works

Claude Code fires lifecycle hooks that receive JSON on stdin. The catch: hooks are only ever handed the session **UUID** (`session_id`), never a friendly name. The friendly name is the `customTitle` you set per session, which Claude Code writes into the session transcript as a line like:

```json
{"type":"custom-title","customTitle":"session logger","sessionId":"af68…383d"}
```

So "translate UUID → name" means reading the `customTitle` out of the transcript whose path the hook is given (`transcript_path`).

The other wrinkle: a brand-new session has no title yet at `SessionStart` (you set it later). So a single record per session is created at start and then **backfilled** with the name once it's known. That's why three events are wired, all to the same script:

| Event | When it fires | Role here |
|-------|---------------|-----------|
| `SessionStart` | session start (any source) | create the record (name may be `null`) |
| `Stop` | end of each assistant turn | backfill the name as soon as it's set, mid-session |
| `SessionEnd` | session end | final name + stamp `ended_at` |

Records are keyed by `session_id`, so resume/clear/compact (which re-fire `SessionStart` on the same UUID) refresh rather than duplicate.

## The script

`session-log.sh` (kept here as a versioned copy; the live copy runs from `~/.claude/hooks/session-log.sh`). It reads the hook JSON, pulls the most recent `custom-title` from the transcript, and upserts one record into `~/.claude/session-log.jsonl` under an `flock` guard:

```bash
# translate UUID -> human title: most recent custom-title line in the transcript
title=$(grep '"type":"custom-title"' "$transcript" | tail -n1 | jq -r '.customTitle // empty')
# ... then jq upserts by session_id; only SessionEnd sets ended_at
```

One record per session looks like:

```json
{"session_id":"af68…","name":"session logger","cwd":"/home/<username>","started_at":"2026-06-18T19:38:28Z","ended_at":null}
```

## Wiring it up

Make the script executable and register the three hooks in `~/.claude/settings.json`:

```bash
chmod +x ~/.claude/hooks/session-log.sh
```

```json
{
  "hooks": {
    "SessionStart": [
      { "hooks": [ { "type": "command", "command": "/home/<username>/.claude/hooks/session-log.sh", "timeout": 10 } ] }
    ],
    "SessionEnd": [
      { "hooks": [ { "type": "command", "command": "/home/<username>/.claude/hooks/session-log.sh", "timeout": 10 } ] }
    ],
    "Stop": [
      { "hooks": [ { "type": "command", "command": "/home/<username>/.claude/hooks/session-log.sh", "timeout": 10 } ] }
    ]
  }
}
```

An absolute path is used deliberately — this is a global logger, not project-scoped, so `$CLAUDE_PROJECT_DIR` is avoided.

**Important:** `SessionStart` (and `UserPromptSubmit`) stdout is injected into Claude's context, so the script writes only to the log file and prints nothing to stdout. `Stop` and `SessionEnd` stdout is ignored, which is why `Stop` is the safe place to backfill names every turn.

## Reading it back

A `sessionlog` function in `~/.bashrc` prints name + working directory, sorted and de-duplicated, with an optional `Nh|Nd|Nw` "since" filter:

```bash
sessionlog() {
  local log="$HOME/.claude/session-log.jsonl"
  [ -f "$log" ] || { echo "sessionlog: no log at $log" >&2; return 1; }
  local cutoff=""
  if [ -n "${1:-}" ]; then
    local n="${1%[hdw]}" u="${1: -1}" secs
    [[ "$n" =~ ^[0-9]+$ ]] || { echo "sessionlog: bad since '$1' (use Nh|Nd|Nw, e.g. 12h 3d 1w)" >&2; return 1; }
    case "$u" in
      h) secs=$(( n * 3600 ))   ;;
      d) secs=$(( n * 86400 ))  ;;
      w) secs=$(( n * 604800 )) ;;
      *) echo "sessionlog: bad since '$1' (use Nh|Nd|Nw, e.g. 12h 3d 1w)" >&2; return 1 ;;
    esac
    cutoff=$(date -u -d "@$(( $(date -u +%s) - secs ))" +%Y-%m-%dT%H:%M:%SZ)
  fi
  jq -r --arg c "$cutoff" '
    select($c == "" or ((.started_at // "") >= $c))
    | [.name // "(unnamed)", .cwd // ""] | @tsv
  ' "$log" | sort -u | column -t -s $'\t'
}
```

```bash
sessionlog          # everything
sessionlog 12h      # sessions started in the last 12 hours
sessionlog 3d       # last 3 days
sessionlog 1w       # last week
```

The "since" filter works on `started_at`; ISO-8601 `Z` timestamps sort chronologically as plain strings, so no per-record date parsing is needed.

## Caveats

- A session you never title logs `name: null` (shown as `(unnamed)`). Claude Code only exposes the UUID — the human name is entirely yours to set.
- The `Stop` hook re-runs the upsert once per turn. It's a cheap `flock`'d rewrite of a small JSONL, but it is per-turn.
- `~/.bashrc` has the usual non-interactive guard at the top, so `source ~/.bashrc` from a non-interactive shell won't define `sessionlog`. A normal interactive terminal (or a new one) picks it up fine.

## Reference

- Claude Code hooks: <https://code.claude.com/docs/en/hooks>
