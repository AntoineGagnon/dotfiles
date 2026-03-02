#!/usr/bin/env bash

set -e

DOTFILES_REPO="git@github.com:AntoineGagnon/dotfiles.git"

# =============================================================================
# Colors & helpers
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

ok()   { echo -e "  ${GREEN}✓${RESET} $1"; RESULTS+=("${GREEN}✓${RESET} $1"); }
fail() { echo -e "  ${RED}✗${RESET} $1"; RESULTS+=("${RED}✗${RESET} $1"); }
info() { echo -e "  ${BLUE}→${RESET} $1"; }
warn() { echo -e "  ${YELLOW}!${RESET} $1"; }
step() { echo -e "\n${BOLD}$1${RESET}"; }

ask() {
  local prompt="$1"
  local var="$2"
  echo -en "  ${YELLOW}?${RESET} ${prompt}: "
  read -r "$var"
}

ask_yn() {
  local prompt="$1"
  echo -en "  ${YELLOW}?${RESET} ${prompt} [y/n] "
  read -r yn
  [[ "$yn" =~ ^[Yy]$ ]]
}

RESULTS=()

# =============================================================================
# Header
# =============================================================================

clear
echo -e "${BOLD}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║        Mac Bootstrap Setup           ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${RESET}"
echo -e "  Setting up a new Mac. Let's go.\n"

# =============================================================================
# Step 1: SSH
# =============================================================================

step "Step 1/11 — SSH Key"

if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
  ok "SSH key already exists"
else
  info "Generating new ed25519 SSH key..."
  ask "Enter your email for the SSH key" ssh_email
  ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519" -N "" && ok "SSH key generated" || { fail "SSH key generation failed"; exit 1; }
fi

eval "$(ssh-agent -s)" > /dev/null
ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519" 2>/dev/null || ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null

mkdir -p "$HOME/.ssh"
if ! grep -q "ssh.github.com" "$HOME/.ssh/config" 2>/dev/null; then
  cat >> "$HOME/.ssh/config" << 'EOF'
Host github.com
    Hostname ssh.github.com
    Port 443
    User git
EOF
  ok "SSH config written"
fi

echo ""
echo -e "  ${BOLD}Your public key:${RESET}"
echo ""
cat "$HOME/.ssh/id_ed25519.pub"
echo ""
info "Add this key to GitHub → https://github.com/settings/ssh/new"
open "https://github.com/settings/ssh/new" 2>/dev/null || true
echo -en "  ${YELLOW}?${RESET} Press Enter once you've added the key to GitHub... "
read -r

if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  ok "GitHub SSH connection verified"
else
  warn "Could not verify GitHub SSH — continuing anyway"
fi

# =============================================================================
# Step 2: Homebrew
# =============================================================================

step "Step 2/11 — Homebrew"

if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && ok "Homebrew installed" || { fail "Homebrew install failed"; exit 1; }
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  ok "Homebrew already installed"
fi

# =============================================================================
# Step 3: brew.sh
# =============================================================================

step "Step 3/11 — Homebrew packages"

if ask_yn "Skip 'brew upgrade'? (faster, packages may be outdated)"; then
  info "Patching brew.sh to skip upgrade..."
  sed 's/^brew upgrade$/# brew upgrade (skipped)/' "$HOME/brew.sh" | bash && ok "brew.sh completed" || fail "brew.sh had errors"
else
  bash "$HOME/brew.sh" && ok "brew.sh completed" || fail "brew.sh had errors"
fi

# =============================================================================
# Step 4: yadm dotfiles
# =============================================================================

step "Step 4/11 — Dotfiles (yadm)"

if command -v yadm &>/dev/null; then
  if yadm status &>/dev/null; then
    ok "yadm already initialized"
    yadm pull && ok "Dotfiles pulled" || fail "yadm pull failed"
  else
    yadm clone "$DOTFILES_REPO" && ok "Dotfiles cloned" || fail "yadm clone failed"
  fi
else
  fail "yadm not found — was brew.sh run successfully?"
fi

# =============================================================================
# Step 5: Shell (oh-my-zsh + plugins + theme)
# =============================================================================

step "Step 5/11 — Shell setup"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing oh-my-zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && ok "oh-my-zsh installed" || fail "oh-my-zsh install failed"
else
  ok "oh-my-zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && ok "zsh-autosuggestions installed" || fail "zsh-autosuggestions failed"
else
  ok "zsh-autosuggestions already installed"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/you-should-use" ]]; then
  git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use "$ZSH_CUSTOM/plugins/you-should-use" && ok "you-should-use installed" || fail "you-should-use failed"
else
  ok "you-should-use already installed"
fi

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k" && ok "powerlevel10k installed" || fail "powerlevel10k failed"
else
  ok "powerlevel10k already installed"
fi

# =============================================================================
# Step 6: Git config
# =============================================================================

step "Step 6/11 — Git config"

ask "Git full name" git_name
ask "Git email" git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global pull.rebase true
ok "Git config set (${git_name} <${git_email}>)"

# =============================================================================
# Step 7: Auth (GitHub / GitLab)
# =============================================================================

step "Step 7/11 — Auth"

echo -e "  Which platforms do you need to authenticate with?"
echo -e "    ${BOLD}1)${RESET} GitHub only"
echo -e "    ${BOLD}2)${RESET} GitLab only"
echo -e "    ${BOLD}3)${RESET} Both"
echo -e "    ${BOLD}4)${RESET} Skip"
echo -en "  ${YELLOW}?${RESET} Choice [1-4]: "
read -r auth_choice

case "$auth_choice" in
  1|3)
    if command -v gh &>/dev/null; then
      gh auth login && ok "GitHub authenticated" || fail "GitHub auth failed"
    else
      fail "gh not found"
    fi
    ;;
esac

case "$auth_choice" in
  2|3)
    if command -v glab &>/dev/null; then
      glab auth login && ok "GitLab authenticated" || fail "GitLab auth failed"
    else
      fail "glab not found"
    fi
    ;;
esac

[[ "$auth_choice" == "4" ]] && warn "Auth skipped"

# =============================================================================
# Step 8: macOS defaults
# =============================================================================

step "Step 8/11 — macOS defaults"

info "Dock..."
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock show-recents -bool false

info "Finder..."
defaults write com.apple.finder FXPreferredViewStyle -string clmv
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder AppleShowAllFiles -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool false

info "Keyboard..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

info "Global..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

info "Restarting Dock & Finder..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

ok "macOS defaults applied"

# =============================================================================
# Step 9: npm globals
# =============================================================================

step "Step 9/11 — npm globals"

if command -v npm &>/dev/null; then
  npm install -g neovim && ok "neovim npm package installed" || fail "neovim npm install failed"
else
  fail "npm not found — skipping npm globals"
fi

# =============================================================================
# Step 10: mise
# =============================================================================

step "Step 10/11 — mise runtimes"

if [[ -f "$HOME/mise.sh" ]]; then
  bash "$HOME/mise.sh" && ok "mise runtimes installed" || fail "mise.sh had errors"
else
  fail "mise.sh not found"
fi

# =============================================================================
# Step 11: Rectangle config
# =============================================================================

step "Step 11/11 — App config"

RECT_PLIST="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"
if [[ -f "$RECT_PLIST" ]]; then
  defaults import com.knollsoft.Rectangle "$RECT_PLIST" && ok "Rectangle config imported" || fail "Rectangle config import failed"
else
  warn "Rectangle plist not found — skipping"
fi

# =============================================================================
# Summary
# =============================================================================

echo ""
echo -e "${BOLD}  ╔══════════════════════════════════════╗"
echo -e "  ║            Summary                   ║"
echo -e "  ╚══════════════════════════════════════╝${RESET}"
echo ""
for result in "${RESULTS[@]}"; do
  echo -e "  $result"
done
echo ""
echo -e "  ${GREEN}${BOLD}Bootstrap complete!${RESET}"
echo -e "  Restart your terminal or run: ${BOLD}exec zsh${RESET}"
echo ""
