# mtr

I reach for `mtr` whenever something on the network path looks wrong — it combines `ping` and `traceroute` into a single live-updating display, continuously probing each hop and showing packet loss and latency at every step. It's the first thing I run when a hosted service starts behaving oddly.

> **Note:** Loss at an intermediate hop doesn't always mean a real problem. Routers commonly rate-limit or deprioritise ICMP — if the final destination shows no loss, the intermediate drop is almost certainly noise. Focus on the last hop.

## Install

```bash
sudo apt install mtr
```

Project homepage: [bitwizard.nl/mtr](https://www.bitwizard.nl/mtr/). Source on [GitHub](https://github.com/traviscross/mtr).

## Basic use

```bash
mtr example.com          # interactive curses display
mtr --no-dns example.com # skip reverse DNS (faster first look)
```

Hit `q` to quit interactive mode.

## Report mode

You'll want `--report` for anything scripted, or when you need a snapshot rather than a live feed:

```bash
mtr --report example.com                     # 10-cycle report, then exit
mtr --report --report-cycles 5 example.com   # 5 cycles instead of 10
mtr --report-wide example.com                # wider columns so hostnames aren't truncated
```

## Useful flags

| Flag | Effect |
|------|--------|
| `-n` / `--no-dns` | show IP addresses only, skip reverse DNS |
| `-b` / `--show-ips` | show both hostname and IP |
| `-r` / `--report` | non-interactive report mode |
| `-w` / `--report-wide` | wide report (avoids host name truncation) |
| `-c N` / `--report-cycles N` | number of pings per hop in report mode (default 10) |
| `-i S` / `--interval S` | seconds between ICMP probes (default 1) |
| `-m N` / `--max-ttl N` | maximum number of hops (default 30) |
| `-u` / `--udp` | use UDP instead of ICMP echo |
| `-T` / `--tcp` | use TCP instead of ICMP echo |
| `-P N` / `--port N` | target port for TCP or UDP mode |
| `-4` | force IPv4 |
| `-6` | force IPv6 |
| `-z` / `--aslookup` | display AS (Autonomous System) number per hop |

## Reading the display

| Column | Meaning |
|--------|---------|
| `Loss%` | percentage of probes lost at this hop |
| `Snt` | total probes sent |
| `Last` | latency of last probe (ms) |
| `Avg` | mean latency |
| `Best` | lowest latency seen |
| `Wrst` | highest latency seen |
| `StDev` | standard deviation — a high value indicates jitter |

## Output formats

Useful when logging results or piping into another tool. I've mostly reached for `--json` with `jq`; the others I haven't had cause to use yet.

```bash
mtr --json example.com     # JSON
mtr --xml example.com      # XML
mtr --csv example.com      # CSV
mtr --raw example.com      # raw format (one line per probe)
```

## Scripting example

```bash
# Report to file, no DNS, 20 cycles
mtr --report --no-dns --report-cycles 20 example.com > mtr-report.txt

# JSON output piped to jq
mtr --json --report example.com | jq '.report.hops[] | {host: .host, loss: .loss}'
```
