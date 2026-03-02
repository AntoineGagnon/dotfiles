#!/usr/bin/env bash

LOG_DIR="${HOME}/.local/share/bootstrap"
LOG_FILE="${LOG_DIR}/brew-$(date +%Y%m%d-%H%M%S).log"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "[$(date)] brew.sh started"
trap 'echo "[$(date)] ERROR at line $LINENO (exit code $?)"' ERR

SKIP_UPGRADE="${SKIP_UPGRADE:-false}"

brew update || true

if [[ "$SKIP_UPGRADE" != "true" ]]; then
  brew upgrade || true
fi

# Auto-update brew daily via LaunchAgent
mkdir -p "${HOME}/Library/LaunchAgents"
cat > "${HOME}/Library/LaunchAgents/homebrew.autoupdate.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>homebrew.autoupdate</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/brew</string>
        <string>update</string>
    </array>
    <key>StartInterval</key>
    <integer>86400</integer>
</dict>
</plist>
EOF
launchctl load "${HOME}/Library/LaunchAgents/homebrew.autoupdate.plist" 2>/dev/null || true

# Add brew to path if not already
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true

BREW_PREFIX=$(brew --prefix)

# Symlink coreutils sha256sum if needed
[[ -f "${BREW_PREFIX}/bin/gsha256sum" ]] && ln -sf "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum" 2>/dev/null || true

# Install from Brewfile
if [[ -f "${HOME}/Brewfile" ]]; then
  brew bundle install --file="${HOME}/Brewfile" && ok "Brewfile installed" || fail "Brewfile install failed"
else
  fail "Brewfile not found at ${HOME}/Brewfile"
fi

# Add custom shell to /etc/shells if needed
if ! grep -qF "${BREW_PREFIX}/bin/bash" /etc/shells 2>/dev/null; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells 2>/dev/null || true
fi

brew cleanup || true

echo "[$(date)] brew.sh completed successfully"
echo "Log saved to: $LOG_FILE"
