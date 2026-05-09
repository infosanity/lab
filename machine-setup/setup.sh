#!/usr/bin/env bash
# Fresh Ubuntu setup — standardises tooling documented in lab/tools
# Run once after a clean install. Safe to re-run; most steps are idempotent.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info()    { echo "[+] $*"; }
warning() { echo "[!] $*"; }
skip()    { echo "[-] $*"; }

# ---------------------------------------------------------------------------
# 1. APT packages
# ---------------------------------------------------------------------------
info "Updating apt and installing packages"
sudo apt-get update -qq
sudo apt-get install -y \
    tree \
    mtr \
    bat \
    jq \
    byobu \
    keychain \
    age \
    whois \
    zip \
    python3-pip \
    python-is-python3 \
    pipx

# ---------------------------------------------------------------------------
# 2. Snap packages
# ---------------------------------------------------------------------------
info "Installing snap packages"
snap list glow    &>/dev/null && skip "glow already installed" \
    || sudo snap install glow

# ---------------------------------------------------------------------------
# 3. Shell aliases
# ---------------------------------------------------------------------------
info "Installing .bash_aliases"
if [[ -f ~/.bash_aliases ]]; then
    warning "~/.bash_aliases already exists — appending repo aliases"
    echo "" >> ~/.bash_aliases
    echo "# --- appended by setup.sh ---" >> ~/.bash_aliases
    cat "$REPO_DIR/zenith/.bash_aliases" >> ~/.bash_aliases
else
    cp "$REPO_DIR/zenith/.bash_aliases" ~/.bash_aliases
fi

# ---------------------------------------------------------------------------
# 4. Nano config
# ---------------------------------------------------------------------------
info "Installing nanorc"
if [[ -f ~/.nanorc ]]; then
    warning "~/.nanorc already exists — appending repo config"
    echo "" >> ~/.nanorc
    echo "# --- appended by setup.sh ---" >> ~/.nanorc
    cat "$REPO_DIR/zenith/nanorc" >> ~/.nanorc
else
    cp "$REPO_DIR/zenith/nanorc" ~/.nanorc
fi

# ---------------------------------------------------------------------------
# 5. tmux / byobu — allow OSC passthrough for remote pane colour-coding
# ---------------------------------------------------------------------------
info "Configuring tmux passthrough"
TMUX_CONF=~/.tmux.conf
if grep -q "allow-passthrough" "$TMUX_CONF" 2>/dev/null; then
    skip "allow-passthrough already set in $TMUX_CONF"
else
    echo "set -g allow-passthrough on" >> "$TMUX_CONF"
fi

# ---------------------------------------------------------------------------
# 6. Python tooling via pipx
# ---------------------------------------------------------------------------
info "Installing pipx tools"
pipx ensurepath &>/dev/null
pipx install black 2>/dev/null || skip "black already installed via pipx"

# ---------------------------------------------------------------------------
# 7. Keychain — add to .bashrc if not present
# ---------------------------------------------------------------------------
info "Checking keychain setup"
if grep -q "keychain" ~/.bashrc 2>/dev/null; then
    skip "keychain already configured in ~/.bashrc"
else
    warning "keychain not configured — add the following to ~/.bashrc once your SSH key is in place:"
    echo
    echo '    eval "$(keychain --eval --agents ssh ~/.ssh/id_ed25519)"'
    echo
fi

# ---------------------------------------------------------------------------
# 8. passage — install from source if not present
# ---------------------------------------------------------------------------
if command -v passage &>/dev/null; then
    skip "passage already installed"
else
    info "Installing passage from source"
    git clone https://github.com/FiloSottile/passage ~/.passage-src
    sudo make -C ~/.passage-src install
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo
info "Setup complete. Remaining manual steps:"
echo
echo "  1. Keychain — SSH key agent persistence across sessions"
echo "     Add to ~/.bashrc (replace id_ed25519 with your key filename):"
echo "         eval \"\$(keychain --eval --agents ssh ~/.ssh/id_ed25519)\""
echo "     Full details: $REPO_DIR/tools/keychain/README.md"
echo
echo "  2. passage — age-based secret store"
echo "     Generate an age keypair and configure passage to use it:"
echo "         age-keygen -o ~/.age/key.txt"
echo "         mkdir -p ~/.passage"
echo "         cp ~/.age/key.txt ~/.passage/identities"
echo "     Back up ~/.age/key.txt securely — losing it means losing all secrets."
echo "     Full details: $REPO_DIR/tools/passage/README.md"
echo
echo "  3. byobu — terminal multiplexer"
echo "     To auto-attach byobu on every login run:"
echo "         byobu-enable"
echo "     Full details: $REPO_DIR/tools/byobu/README.md"
echo
echo "  4. Reload your shell to pick up all changes:"
echo "         exec \$SHELL"
