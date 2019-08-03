#-------------------------------------------------------------------------------
# PATH
#-------------------------------------------------------------------------------

SYSTEM_PATH=$PATH
unset PATH

PATH=$HOME/.zsh/bin
PATH=$PATH:$HOME/.local/bin
PATH=$PATH:$HOME/.composer/vendor/bin
PATH=$PATH:$HOME/.yarn/bin
PATH=$PATH:$HOME/.config/yarn/global/node_modules/.bin
PATH=$PATH:$GOPATH/bin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:$SYSTEM_PATH
export -U PATH

#-------------------------------------------------------------------------------
# OPTIONS
#-------------------------------------------------------------------------------

setopt autocd              # Auto cd into directory by name
setopt autoparamslash      # Tab completing directory appends a slash
setopt autopushd           # cd automatically pushes old dir onto dir stack
setopt completealiases     # Do not expand aliases before completion finishes
setopt completeinword      # Completion from both ends
setopt correct             # Spell check commands
setopt extendedhistory     # Add timestamps to history
setopt histignorealldups   # Prevent recording dupes in history
setopt histignorespace     # Do not save commands with leading space to history
setopt histreduceblanks    # Remove superfluous blanks from history
setopt histverify          # Prevent auto execute expanded history command
setopt ignoreeof           # Prevent exit on eof
setopt incappendhistory    # Adds history incrementally
setopt interactivecomments # Allow comments, even in interactive shells
setopt localoptions        # Allow functions to have local options
setopt localtraps          # Allow functions to have local traps
setopt nobgnice            # Do not nice background tasks
setopt promptsubst         # Expansion and substitution performed in prompts
setopt pushdignoredups     # Prevent pushing multiple copies of same dir onto stack
setopt pushdsilent         # Do not print dir stack after pushing/popping
setopt sharehistory        # Share history between sessions

#-------------------------------------------------------------------------------
# EXPORTS
#-------------------------------------------------------------------------------

export EDITOR=nvim
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTIGNORE="fg"
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export WORDCHARS='*?[]~&;!$%^<>'
export VIRTUAL_ENV_DISABLE_PROMPT=1
export BAT_THEME=Nord
export HOMEBREW_NO_ANALYTICS=1

# Setup dircolors
command -v dircolors >/dev/null && [ -f "$HOME"/.dir_colors ] && eval $(dircolors $HOME/.dir_colors)
command -v gdircolors >/dev/null && [ -f "$HOME"/.dir_colors ] && eval $(gdircolors $HOME/.dir_colors)

# For ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# For fzf
export FZF_DEFAULT_COMMAND='rg --files --smart-case --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='
  --height 40%
  --border
  --color=fg:15
  --color=fg+:3
  --color=hl:-1
  --color=hl+:3
  --color=bg:-1
  --color=bg+:-1
  --color=info:-1
  --color=prompt:-1
  --color=marker:1
  --color=header:4
  --color=pointer:-1
  --color=border:#2E3440
'

#-------------------------------------------------------------------------------
# KEYS
#-------------------------------------------------------------------------------

# Use emacs key bindings
bindkey -e

# Make search up and down work
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Also do history expansion on space
bindkey ' ' magic-space

bindkey "^K" kill-whole-line
bindkey "^R" history-incremental-search-backward
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^D" delete-char
bindkey "^F" forward-char
bindkey "^B" backward-char

# Use "cbt" capability ("back_tab", as per `man terminfo`), if we have it:
if tput cbt &> /dev/null; then
  bindkey "$(tput cbt)" reverse-menu-complete # Make Shift-tab go to previous completion
fi

# Allow C-x C-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Magic Enter
function magic-enter () {
  if [[ -z $BUFFER ]]; then
    zle clear-screen
  else
    zle accept-line
  fi
}
zle -N magic-enter
bindkey '^M' magic-enter

#-------------------------------------------------------------------------------
# ALIASES
#-------------------------------------------------------------------------------

alias digg="dig +multiline +noall +answer -t ANY"
alias dots="cd $HOME/Projects/Life/computer"
alias e="$EDITOR"
alias fixterm='echo -e "\e<"; reset; stty sane; tput rs1; clear; echo -e "\033c"'
alias g='git'
alias grep='grep --color'
alias l='tree -L 1'
alias ll='tree -L 2'
alias lll='tree -L 3'
alias llll='tree -L 4'
alias notes="$EDITOR $HOME/Dropbox/Notes"
alias nv="nvim"
alias nvd="nvim -d"
alias pipenvsh="pipenv shell --fancy"
alias q=exit
alias t='tmux -u'
alias v=view
alias vi=vim
alias vgs="vagrant global-status"
alias zr!="source $HOME/.zshrc"

# Need special case for macos
if [ "$(uname)" = 'Darwin' ]; then
  alias ls='gls --color=auto'
  alias lls='gls --color=auto -al'
else
  alias ls='ls --color=auto'
  alias lls='ls --color=auto -al'
fi

#-------------------------------------------------------------------------------
# COMPLETION
#-------------------------------------------------------------------------------

# Make completion:
# - Case-insensitive
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar)
# - Substring complete (ie. bar -> foobar)
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Visual select
zstyle ':completion:*' menu select
# Pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
# Don't autocomplete hosts
zstyle ':completion:*:ssh:*' hosts off
# Color ls completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zsh_completions=/usr/local/share/zsh-completions
if [ -d $zsh_completions ]; then
  fpath=($zsh_completions $fpath)
fi
unset zsh_completions

autoload -U compinit
compinit

# Make aliased completions work
compdef g=git
compdef t=tmux

#-------------------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------------------

source "$HOME/.zsh/functions.zsh"

# Adds `cdr` command for navigating to recent directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# Enable menu-style completion for cdr
zstyle ':completion:*:*:cdr:*:*' menu selection

# Fall through to cd if cdr is passed a non-recent dir as an argument
zstyle ':chpwd:*' recent-dirs-default true

#-------------------------------------------------------------------------------
# PROMPT
#-------------------------------------------------------------------------------

source "$HOME/.zsh/prompt.zsh"

#-------------------------------------------------------------------------------
# SETUP OTHER SCRIPTS/PROGRAMS
#-------------------------------------------------------------------------------

# Setup rbenv
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - --no-rehash)"
fi

# Use fasd
if command -v fasd >/dev/null 2>&1; then
  eval "$(fasd --init auto)"
fi

# fzf
FZF_ZSH="${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
test -f $FZF_ZSH && source $FZF_ZSH
unset FZF_ZSH

# zsh-autosuggestions and zsh-syntax-highlighting
function() {
  local -a locations
  local file

  locations=(
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  )

  for file in $locations; do
    if [ -f $file ]; then
      source $file
    fi
  done
}

ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_HIGHLIGHT_STYLES[path]="none"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red"
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=magic-enter

# Use .zshrc.local for local options
LOCAL_RC="$HOME/.zshrc.local"
test -f $LOCAL_RC && source $LOCAL_RC
unset LOCAL_RC

#-------------------------------------------------------------------------------
# NVM
#-------------------------------------------------------------------------------

# node may be set to a specific version from ~/.zshrc.local
# If it isn't, then load up nvm but do it asynchronously
if ! command -v node >/dev/null 2>&1; then
  # https://github.com/creationix/nvm/issues/539#issuecomment-403661578

  # Setup zsh-async
  source "$HOME/.zsh/async.zsh"
  async_init

  export NVM_DIR="$HOME/.config/nvm"

  function load-nvm() {
    # /usr/local/opt/nvm/nvm.sh is the expected path when nvm is managed by Homebrew
    local nvmsh="/usr/local/opt/nvm/nvm.sh"
    [ -s "$nvmsh" ] && source "$nvmsh"
  }

  # Initialize a new worker to load (source) nvm.sh
  async_start_worker nvm-worker
  async_job nvm-worker load-nvm
fi
