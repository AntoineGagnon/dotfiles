# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Platform detection
if [[ -z "${IS_MACOS:-}" ]]; then
  if [[ "$(uname -s)" == "Darwin" ]]; then
    readonly IS_MACOS=true
  else
    readonly IS_MACOS=false
  fi
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if $IS_MACOS; then
  export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools:$HOME/Library/Android/sdk/emulator:$HOME/Library/Android/sdk/:$HOME/Library/Android/sdk/cmdline-tools/latest/bin"
  export ANDROID_HOME="$HOME/Library/Android/sdk"
else
  export ANDROID_HOME="$HOME/Android/Sdk"
  export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin"
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
  thefuck
  you-should-use
  zsh-autosuggestions
)
if $IS_MACOS; then
  plugins+=(brew iterm2 sublime)
fi

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
if $IS_MACOS; then
  eval "$(/opt/homebrew/bin/mise activate zsh)"
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
  fi
  if command -v zsh-syntax-highlighting &>/dev/null; then
    source zsh-syntax-highlighting.zsh
  elif [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  elif [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
fi

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$PATH:$HOME/.opencode/bin:$HOME/.rvm/bin:$HOME/.lmstudio/bin:$HOME/.local/bin"

if $IS_MACOS; then
  ### lyft_localdevtools_shell_rc start
  ### DO NOT REMOVE: automatically installed as part of Lyft local dev tool setup
  if [[ -f "/opt/homebrew/Library/Taps/lyft/homebrew-localdevtools/scripts/shell_rc.sh" ]]; then
      source "/opt/homebrew/Library/Taps/lyft/homebrew-localdevtools/scripts/shell_rc.sh"
  fi
  ### lyft_localdevtools_shell_rc end

  ### DO NOT REMOVE: automatically installed as part of Lyft local dev tool setup
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

  ### lyft_rd_shell_rc start
  ### DO NOT REMOVE: automatically installed as part of Rancher Desktop setup
  if [[ -f /Users/agagnon/.rd/shell_rc.sh ]]; then
    source /Users/agagnon/.rd/shell_rc.sh
  fi
  ### lyft_rd_shell_rc end
fi

# fnm
FNM_PATH="/home/antoine/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

# Added by flyctl installer
export FLYCTL_INSTALL="/home/antoine/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
