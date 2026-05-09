# machine-setup

## What this is

Every time I set up a fresh machine I spend the first hour reinstalling the same things — which is fine the, until it's not. This script gets a fresh Ubuntu install to a useful state without the tedium.

It's not exhaustive, may not always work (I'm not $deity, and packages change faster than I can keep pace), so it's not a replacement for RTFM. It's a reasonable starting point that gets the basics in place and reminds me steps what still needs doing by hand.

## What it installs

- **apt packages** — tree, mtr, bat, jq, byobu, keychain, age, whois, zip, pipx and the Python stack
- **snap packages** — glow (markdown terminal renderer)
- **dotfiles** — `.bash_aliases` and `.nanorc` from the `zenith/` reference config; appended rather than overwritten if they already exist
- **tmux config** — enables OSC passthrough so remote panes can colour-code themselves
- **pipx tools** — black (Python formatter)
- **passage** — built from source, since there's no package

See the individual READMEs under `tools/` for what each tool actually does and why it's here.

## What it doesn't do

Three things are intentionally left as manual steps at the end:

- **Keychain** — needs your SSH key filename, which I can't script the guessing of with my limited powers
- **passage key setup** — generating and backing up an age keypair isn't something to automate, don't roll your own crypto folks....
- **byobu-enable** — personal preference whether you want byobu on every login (I usually do, but sometimes re-purpose this script for remote servers, where I probably don't - byobu-inception melts my brain)

It'll tell you what's still to do when it's done.

## Usage

git clone (if you're readin this you probably already have), then run:

```bash
bash machine-setup/setup.sh
```

Follow the manual steps printed at the end before closing the terminal; and if you hit any problems, raise me an Issue in GitHub's bug tracker....
