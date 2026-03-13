# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools:$HOME/go/bin:$HOME/Library/Android/sdk/emulator:$HOME/Library/Android/sdk/:$HOME/Library/Android/sdk/cmdline-tools/latest/bin"

export ANDROID_HOME="$HOME/Library/Android/sdk"

export ZSH="$HOME/.oh-my-zsh"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

plugins=(
  alias-finder
  brew
  common-aliases
  git
  git-extras
  gradle
  iterm2
  sublime
  thefuck
  you-should-use
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

zstyle ':omz:plugins:alias-finder' autoload yes
zstyle ':omz:plugins:alias-finder' longer yes
zstyle ':omz:plugins:alias-finder' exact yes
zstyle ':omz:plugins:alias-finder' cheaper yes

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Load aliases and functions
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions.zsh ]] && source ~/.functions.zsh

# Load .zshrc.local last (machine-specific config)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Load prompt config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Tools
eval "$(~/.local/bin/mise activate zsh)"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$PATH:$HOME/.opencode/bin:$HOME/.rvm/bin:$HOME/.lmstudio/bin"
