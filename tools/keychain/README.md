# Keychain on WSL

`keychain` wraps `ssh-agent` so keys survive across shell sessions without re-prompting for passphrases.

## Install

```bash
sudo apt install keychain
```

## Configure

Add to `~/.bashrc`:

```bash
eval "$(keychain --eval --agents ssh ~/.ssh/id_ed25519)"
```

Replace `id_ed25519` with your key filename. List multiple keys space-separated if needed.

## How it works

- On first login, keychain starts `ssh-agent` and loads the specified key (prompting for passphrase once).
- Subsequent shells re-use the running agent via a socket file in `~/.keychain/`, so no repeated prompts.
- On WSL, the agent persists for the lifetime of the WSL session (dies when WSL shuts down).

## Verify

```bash
ssh-add -l    # lists loaded keys
```

## Useful flags

| Flag | Effect |
|------|--------|
| `--quiet` | suppress startup messages |
| `--noask` | don't prompt for passphrase on startup (add key manually later with `ssh-add`) |
| `--timeout 60` | auto-expire keys after 60 minutes |
