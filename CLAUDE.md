# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal lab and reference repository ("Mad Wizard's Dungeon Experiments"). Content is a mix of markdown cheatsheets, skeleton code, and configuration files. There is no build system, test suite, or CI pipeline.

## Structure

Each top-level directory covers a technology domain:

- `zenith/` — setup/config for the primary dev machine (Windows 11 + WSL Ubuntu + Rancher Desktop). Contains `.bash_aliases` and `apt.common`.
- `gh0st/` — Ubuntu server running MicroK8s.
- `k8s/` — Kubernetes cheatsheet and YAML skeletons (pod, deployment, cron).
- `docker/` — Docker cheatsheet and a Python proof-of-concept Dockerfile.
- `cloudflare/` — Notes on `cloudflared` tunnels and WARP client setup.
- `python/` — Python snippets and notes (`click` CLI skeleton, `configparser` reference).
- `tools/` — Notes on dev tooling; each tool has its own subdirectory with a `README.md` (e.g. `bat/`, `byobu/`, `glow/`, `jq/`, `keychain/`, `neofetch/`, `passage/`, `pv/`).

## Conventions

- Docs are markdown with fenced code blocks for commands and snippets.
- Skeleton files (e.g. `click-skeleton.py`, `k8s/skeleton-*.yaml`) are minimal working starting points, not complete implementations.
- `zenith/.bash_aliases` defines shell aliases used on the dev machine; git tree-view aliases (`glt`, `glta`) live there.
- Commit messages follow the pattern `type: description` (e.g. `doc:`, `feat:`, `fix:`).
