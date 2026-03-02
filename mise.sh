#!/usr/bin/env bash

set -e

LOG_DIR="${HOME}/.local/share/bootstrap"
LOG_FILE="${LOG_DIR}/mise-$(date +%Y%m%d-%H%M%S).log"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "[$(date)] mise.sh started"
trap 'echo "[$(date)] ERROR: mise.sh failed at line $LINENO (exit code $?)"' ERR

if ! command -v mise &>/dev/null; then
  echo "[$(date)] ERROR: mise is not installed. Run brew.sh first."
  exit 1
fi

# =============================================================================
# Global runtimes
# =============================================================================

mise use --global go@latest
mise use --global python@3.13
mise use --global node@lts
mise use --global java@temurin-21

# =============================================================================
# Global tools
# =============================================================================

mise use --global golangci-lint@latest

# =============================================================================
# Activate
# =============================================================================

mise install

# =============================================================================
# Python post-install: neovim provider
# =============================================================================

mise exec python -- pip install --upgrade pynvim

echo "[$(date)] mise.sh completed successfully"
echo "Log saved to: $LOG_FILE"
