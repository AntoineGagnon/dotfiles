# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:~/Library/Android/sdk/platform-tools:~/go/bin:~/Library/Android/sdk/emulator:~/Library/Android/sdk/:~/Library/Android/sdk/cmdline-tools/latest/bin

export ANDROID_HOME="~/Library/Android/sdk"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Fastlane lang setup
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# JIRA CLI
export JIRA_API_TOKEN=REDACTED

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
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

# User configuration

zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias st.="st ."
alias zshconfig="st ~/.zshrc"
alias gs="git status"
alias podi="bundle exec pod install"
alias cleanup="git checkout .  > /dev/null && git clean -df > /dev/null && echo 'Done !'"
alias pj='f() { cd `pj-go $1` };f'
alias statusCurl="curl -o /dev/null -s -w \"%{http_code}\""
alias todo="nvim ~/todo/"

# Android aliases
alias adbPackages="adb shell pm list packages"
alias adbBack="adb shell input keyevent KEYCODE_BACK"
alias adbSettings="adb shell am start -a android.settings.SETTINGS"
alias phone="adb connect 192.168.86.33 && scrcpy --tcpip"
alias screenshot="adb exec-out screencap -p > ~/Desktop/Screenshots/Android/screen-$(date -j "+%Y-%m-%d\ %Hh\ %Mm\ %Ss").png"
alias resetProxy="bash /Applications/Proxyman.app/Contents/Frameworks/ProxymanCore.framework/Resources/install_certificate_android_emulator.sh revertProxy"


# Swift aliases
alias sft="git diff --name-only --diff-filter=d | grep '\.swift$' | xargs swiftformat"


# Random alias
alias wn="afplay ~/Documents/white-noise.mp3"

alias lq="cd ~/Code/lqsignature/"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(~/.local/bin/mise activate zsh)"

# bun completions
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="~/Library/Application Support/Herd/config/php/84/"


# Herd injected PHP binary.
export PATH="~/Library/Application Support/Herd/bin/":$PATH
eval "$(gh copilot alias -- zsh)"

export PATH="~/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="~/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# opencode
export PATH=~/.opencode/bin:$PATH

# SSL
export SSL_CERT_FILE=/Users/gagnoat/Documents/LQACENT50001P.pem
export NODE_EXTRA_CA_CERTS=/Users/gagnoat/Documents/LQACENT50001P.pem
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/gagnoat/.lmstudio/bin"
# End of LM Studio CLI section

function setup-certs() {
  # place to put the combined certs
  local cert_path="$HOME/.certs/all.pem"
  local cert_dir=$(dirname "${cert_path}")
  [[ -d "${cert_dir}" ]] || mkdir -p "${cert_dir}"
  # grab all the certs
  security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > "${cert_path}"
  security find-certificate -a -p /Library/Keychains/System.keychain >> "${cert_path}"
  # configure env vars for commonly used tools
  export GIT_SSL_CAINFO="${cert_path}"
  export AWS_CA_BUNDLE="${cert_path}"
  export NODE_EXTRA_CA_CERTS="${cert_path}"
  # add the certs for npm and yarn
  # and since we have certs, strict-ssl can be true
  npm config set -g cafile "${cert_path}"
  npm config set -g strict-ssl true
}
setup-certs
