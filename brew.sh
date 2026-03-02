#!/usr/bin/env bash

set -e

SKIP_UPGRADE="${SKIP_UPGRADE:-false}"

brew update || true
if [[ "$SKIP_UPGRADE" != "true" ]]; then
  brew upgrade || true
fi

BREW_PREFIX=$(brew --prefix)

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

# =============================================================================
# Core Utilities
# =============================================================================

brew install coreutils
[[ -f "${BREW_PREFIX}/bin/gsha256sum" ]] && ln -sf "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum" || true

brew install moreutils
brew install findutils
brew install gnu-sed
brew install grep
brew install gmp
brew install openssh
brew install screen

# =============================================================================
# Shells & Completion
# =============================================================================

brew install bash
brew install bash-completion2
brew install zsh-syntax-highlighting

if ! grep -qF "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
  chsh -s "${BREW_PREFIX}/bin/bash"
fi

# =============================================================================
# Development Tools
# =============================================================================

brew install mise
brew install luarocks
brew install acli

# Git tools
brew install gh
brew install glab
brew install git
brew install git-lfs
brew install lazygit
brew install yadm

# Text editors
brew install neovim
brew install vim

# Code formatters & linters
brew install ktlint
brew install swiftformat
brew install prettier
brew install markdownlint-cli2
brew install ast-grep

# =============================================================================
# CLI Utilities
# =============================================================================

brew install ack
brew install bat
brew install eza
brew install fd
brew install fzf
brew install jq
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install ripgrep
brew install rlwrap
brew install ssh-copy-id
brew install thefuck
brew install tree
brew install vbindiff
brew install wget
brew install zopfli
brew install glances

# =============================================================================
# System & Monitoring
# =============================================================================

brew install fastfetch

# =============================================================================
# Multimedia
# =============================================================================

brew install ffmpeg
brew install imagemagick
brew install ghostscript
brew install mermaid-cli

# Font tools
brew install sfnt2woff-zopfli
brew install woff2

# =============================================================================
# Network & Web
# =============================================================================

brew install curl
brew install lynx

# =============================================================================
# GPG & Security
# =============================================================================

brew install gnupg

# =============================================================================
# Cask Applications
# =============================================================================

# Terminals
brew install --cask alacritty
brew install --cask iterm2
brew install --cask kitty

# Window management
brew install --cask alt-tab
brew install --cask rectangle

# Communication
brew install --cask slack

# Media
brew install --cask spotify
brew install --cask vlc

# Development
brew install --cask bruno

# Launchers & tools
brew install --cask raycast
brew install --cask boring-notch

# Fonts
brew install --cask font-jetbrains-mono

# =============================================================================
# Cleanup
# =============================================================================

brew cleanup
