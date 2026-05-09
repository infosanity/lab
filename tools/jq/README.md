# jq

`jq` is a command-line JSON processor. Filters transform a JSON input stream; the output is always valid JSON (unless `--raw-output` is used).

## Install

```bash
sudo apt install jq
```

## Common operations

```bash
# Pretty-print
cat data.json | jq .
jq . data.json

# Extract a field
jq '.name' data.json

# Nested field
jq '.user.email' data.json

# Array index
jq '.[0]' data.json

# All elements of an array
jq '.[]' data.json

# Field from each element of an array
jq '.[].name' data.json
```

## Filtering and selecting

```bash
# Select elements matching a condition
jq '.[] | select(.status == "active")' data.json

# Select where field exists
jq '.[] | select(.error != null)' data.json

# First match
jq 'first(.[] | select(.type == "admin"))' data.json
```

## Reshaping output

```bash
# Build a new object
jq '{id: .id, label: .name}' data.json

# Build from array elements
jq '[.[] | {id: .id, label: .name}]' data.json

# Extract array of a single field
jq '[.[].name]' data.json

# Keys of an object
jq 'keys' data.json
```

## Raw output (no JSON quoting)

```bash
jq -r '.name' data.json           # string without surrounding quotes
jq -r '.[].id' data.json          # one value per line
```

## Useful with AWS CLI

```bash
aws ec2 describe-instances | jq '.Reservations[].Instances[] | {id: .InstanceId, state: .State.Name}'

aws s3api list-buckets | jq -r '.Buckets[].Name'
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-r` | raw string output (strip JSON quotes) |
| `-c` | compact output (single line) |
| `-e` | exit status reflects whether result is `false`/`null` |
| `--arg name val` | pass a shell variable into the filter as `$name` |
| `--argjson name val` | pass a JSON value into the filter as `$name` |
| `-s` | slurp — read entire input into one array |
| `-n` | null input — filter runs without reading stdin |

## Passing shell variables

```bash
STATUS="active"
jq --arg s "$STATUS" '.[] | select(.status == $s)' data.json
```
