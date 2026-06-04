# Platform detection
if [[ -z "${IS_MACOS:-}" ]]; then
  [[ "$(uname -s)" == "Darwin" ]] && readonly IS_MACOS=true || readonly IS_MACOS=false
fi

# Enable Powerlevel10k instant prompt. Must stay near top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$PATH:$HOME/go/bin"
export ZSH="$HOME/.oh-my-zsh"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

plugins=(
  alias-finder
  common-aliases
  git
  git-extras
  gradle
  you-should-use
  zsh-autosuggestions
)
$IS_MACOS && plugins+=(brew iterm2 sublime)

source $ZSH/oh-my-zsh.sh

zstyle ':omz:plugins:alias-finder' autoload yes
zstyle ':omz:plugins:alias-finder' longer yes
zstyle ':omz:plugins:alias-finder' exact yes
zstyle ':omz:plugins:alias-finder' cheaper yes

[[ -n $SSH_CONNECTION ]] && export EDITOR='vim' || export EDITOR='nvim'

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions.zsh ]] && source ~/.functions.zsh
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:$HOME/.opencode/bin:$HOME/.rvm/bin:$HOME/.lmstudio/bin:$HOME/.local/bin"

if $IS_MACOS; then
  source ~/.zshrc.macos
else
  source ~/.zshrc.linux
fi
