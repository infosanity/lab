#!/usr/bin/env bash
# Logs Claude Code sessions to ~/.claude/session-log.jsonl.
# One record per session_id; the human title is translated from the
# transcript's custom-title line. SessionStart creates/refreshes the record,
# SessionEnd backfills the final title and end time. Prints nothing to stdout
# (SessionStart stdout would otherwise be injected into Claude's context).
set -euo pipefail

LOG="$HOME/.claude/session-log.jsonl"
LOCK="$HOME/.claude/session-log.lock"

input=$(cat)
get() { jq -r --arg k "$1" '.[$k] // empty' <<<"$input"; }

session_id=$(get session_id)
[ -z "$session_id" ] && exit 0
cwd=$(get cwd)
transcript=$(get transcript_path)
event=$(get hook_event_name)

# Translate UUID -> human title: most recent custom-title line in the transcript.
title=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  title=$(grep '"type":"custom-title"' "$transcript" 2>/dev/null \
            | tail -n1 | jq -r '.customTitle // empty' 2>/dev/null) || true
fi

now=$(date -u +%Y-%m-%dT%H:%M:%SZ)

exec 9>"$LOCK"
flock 9
touch "$LOG"
tmp=$(mktemp)

# Upsert by session_id: keep all other records, update/insert this one.
jq -c -s \
  --arg sid "$session_id" \
  --arg title "$title" \
  --arg cwd "$cwd" \
  --arg now "$now" \
  --arg event "$event" '
  ( [ .[] | select(.session_id != $sid) ] ) as $others
  | ( [ .[] | select(.session_id == $sid) ] | .[0]
      // { session_id: $sid, name: null, cwd: $cwd, started_at: $now, ended_at: null } ) as $rec
  | $rec
    | (if $title != "" then .name = $title else . end)
    | (if (.cwd // "") == "" then .cwd = $cwd else . end)
    | (if $event == "SessionEnd" then .ended_at = $now else . end)
  | ($others + [ . ])
  | .[]
' "$LOG" > "$tmp" && mv "$tmp" "$LOG"

exit 0
