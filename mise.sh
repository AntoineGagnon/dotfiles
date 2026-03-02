#!/usr/bin/env bash

set -e

if ! command -v mise &>/dev/null; then
  echo "mise is not installed. Run brew.sh first."
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
