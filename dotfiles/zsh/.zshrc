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

export HISTFILE="$XDG_DATA_HOME"/zsh/history
export HISTIGNORE="fg"
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export WORDCHARS='*?[]~&;!$%^<>'
export BAT_THEME=Nord
export HOMEBREW_NO_ANALYTICS=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export EDITOR=nvim
export LESSHISTFILE=-

# For fzf
export FZF_DEFAULT_COMMAND='rg -u --files --smart-case'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude ".git" .'
export FZF_DEFAULT_OPTS='
  --height 40%
  --border=sharp
  --color=fg:15
  --color=fg+:3
  --color=hl:-1
  --color=hl+:3
  --color=bg:-1
  --color=bg+:-1
  --color=info:-1
  --color=prompt:-1
  --color=marker:2
  --color=header:2
  --color=pointer:3
  --color=border:#1a1d23
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

alias e="$EDITOR"
alias g='git'
alias grep='grep --color'
alias l='tree -L 1'
alias ll='tree -L 2'
alias lll='tree -L 3'
alias llll='tree -L 4'
alias ls='gls --color=auto'
alias lls='gls --color=auto -al'
alias nv="nvim"
alias nvd="nvim -d"
alias q=exit
alias t='tmux'
alias tkill='tmux kill-server'
alias v=view
alias vi=vim
alias vgs="vagrant global-status"
alias zr!="source $ZDOTDIR/.zshrc"

# https://github.com/pyenv/pyenv/issues/106#issuecomment-440826532
if command -v pyenv >/dev/null 2>&1; then
  alias brew='env PATH=${PATH//$(pyenv root)\/shims:/} brew'
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
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# zsh-completions
source $ZDOTDIR/plugins/zsh-completions/zsh-completions.plugin.zsh

autoload -U compinit
compinit

# Include hidden files
_comp_options+=(globdots)

#-------------------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------------------

source "$ZDOTDIR/functions.zsh"

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

source "$ZDOTDIR/prompt.zsh"

#-------------------------------------------------------------------------------
# SETUP OTHER SCRIPTS/PROGRAMS
#-------------------------------------------------------------------------------

source $ZDOTDIR/plugins/zsh-defer/zsh-defer.plugin.zsh

function defer-load() {
  test -f "$1" && zsh-defer -t 0.5 source "$1"
}

defer-load $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
defer-load $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
defer-load "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
defer-load $ZDOTDIR/plugins/z.sh

unfunction defer-load

# zsh-syntax-highlighting
declare -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]="none"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red"

# zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=magic-enter

# pyenv
if command -v pyenv &>/dev/null; then
  zsh-defer -t 2 eval "$(pyenv init - --no-rehash)"
fi

# rbenv
if command -v rbenv &>/dev/null; then
  zsh-defer -t 2 eval "$(rbenv init - --no-rehash)"
fi

# Setup dircolors
DIRCOLORS_PATH="$XDG_CONFIG_HOME/dircolors/nord.dircolors"
command -v gdircolors >/dev/null && test -f $DIRCOLORS_PATH && eval $(gdircolors $DIRCOLORS_PATH)
unset DIRCOLORS_PATH

#-------------------------------------------------------------------------------
# LOCAL OPTIONS
#-------------------------------------------------------------------------------

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
