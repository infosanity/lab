#!/usr/bin/env bash
set -euo pipefail

file=$(jq -r '.tool_input.file_path // empty')

[[ -z "$file" || "$file" != *.md ]] && exit 0

output=$(pymarkdown scan "$file" 2>&1) || true

if [[ -n "$output" ]]; then
    jq -n --arg msg "pymarkdown: $output" '{"systemMessage": $msg}'
fi
