# dotfiles

My personal macOS dotfiles, managed with [yadm](https://yadm.io).

## Fresh Mac Setup

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AntoineGagnon/dotfiles/master/bootstrap.sh)
```

That's it. The script will guide you through everything.

## What it sets up

1. **Homebrew** — package manager
2. **Dotfiles** — clones this repo via yadm (HTTPS first, then SSH)
3. **Homebrew packages** — all tools, apps and fonts from `Brewfile`
4. **Shell** — oh-my-zsh, zsh-autosuggestions, you-should-use, powerlevel10k
5. **Aliases & Functions** — split into `.aliases` and `.functions.zsh`
6. **Git** — global name/email, rebase on pull, global gitignore
7. **SSH** — generates ed25519 key, adds to agent, switches yadm remote to SSH
8. **Auth** — GitHub (`gh`) and/or GitLab (`glab`)
9. **macOS defaults** — dock, finder, keyboard, screenshots, trackpad
10. **mise** — Go, Python, Node, Java runtimes + golangci-lint
11. **npm globals** — neovim provider
12. **App configs** — Rectangle, rcmd

## Logs

Every script writes a timestamped log to `~/.local/share/bootstrap/`.

```bash
ls ~/.local/share/bootstrap/
cat ~/.local/share/bootstrap/brew-*.log
```

## Mac App Store

Some apps need manual install from the Mac App Store:

- **rcmd** — the config will be restored automatically by bootstrap

## Machine-specific config

Anything that shouldn't be in this repo (work tokens, aliases, SSL certs) goes in `~/.zshrc.local` — sourced automatically by `.zshrc` but never tracked by yadm.

## Scripts

| Script | Purpose |
|--------|---------|
| `bootstrap.sh` | Full setup from scratch |
| `brew.sh` | Install/update all Homebrew packages |
| `mise.sh` | Install global language runtimes |
