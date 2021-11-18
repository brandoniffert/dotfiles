#------------------------------------------------------------------------------
#-- Options -------------------------------------------------------------------
#------------------------------------------------------------------------------

setopt AUTO_CD              # Auto cd into directory by name
setopt AUTO_PARAM_SLASH     # Tab completing directory appends a slash
setopt AUTO_PUSHD           # cd automatically pushes old dir onto dir stack
setopt COMPLETE_ALIASES     # Do not expand aliases before completion finishes
setopt COMPLETE_IN_WORD     # Completion from both ends
setopt CORRECT              # Spell check commands
setopt EXTENDED_HISTORY     # Add timestamps to history
setopt GLOB_DOTS            # Allow hidden files to be matched
setopt HIST_FIND_NO_DUPS    # don't show dups when searching history
setopt HIST_IGNORE_ALL_DUPS # Prevent recording dupes in history
setopt HIST_IGNORE_SPACE    # Do not save commands with leading space to history
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from history
setopt HIST_VERIFY          # Prevent auto execute expanded history command
setopt INC_APPEND_HISTORY   # Adds history incrementally
setopt INTERACTIVE_COMMENTS # Allow comments, even in interactive shells
setopt LIST_PACKED          # make completion lists more densely packed
setopt LOCAL_OPTIONS        # Allow functions to have local options
setopt LOCAL_TRAPS          # Allow functions to have local traps
setopt NO_BG_NICE           # Do not nice background tasks
setopt PROMPT_SUBST         # Expansion and substitution performed in prompts
setopt PUSHD_IGNORE_DUPS    # Prevent pushing multiple copies of same dir onto stack
setopt PUSHD_SILENT         # Do not print dir stack after pushing/popping
setopt SHARE_HISTORY        # Share history between sessions

#------------------------------------------------------------------------------
#-- Exports -------------------------------------------------------------------
#------------------------------------------------------------------------------

export HISTFILE="$XDG_DATA_HOME"/zsh/history
export HISTIGNORE="fg"
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export WORDCHARS='*?[]~&;!$%^<>'

#------------------------------------------------------------------------------
#-- Key Bindings --------------------------------------------------------------
#------------------------------------------------------------------------------

# Use emacs key bindings
bindkey -e

bindkey '^r'   history-incremental-pattern-search-backward # ctrl-r
bindkey '^[k'  kill-line                                   # alt+k
bindkey '^[j'  backward-kill-line                          # alt+j
bindkey '^[[Z' reverse-menu-complete                       # shift-tab
bindkey '^[m'  copy-prev-shell-word                        # alt-m

# Make search up and down work
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Also do history expansion on space
bindkey ' ' magic-space

# Allow C-x C-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Clear the screen if enter is pressed on an empty buffer
function bti-magic-enter () {
  [[ -z $BUFFER ]] && zle clear-screen || zle accept-line
}
zle -N bti-magic-enter
bindkey '^M' bti-magic-enter

# Make CTRL-Z background things and unbackground them
function bti-fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg &> /dev/null
  else
    zle push-input
  fi
}
zle -N bti-fg-bg
bindkey '^Z' bti-fg-bg

#------------------------------------------------------------------------------
#-- Aliases -------------------------------------------------------------------
#------------------------------------------------------------------------------

alias e="$EDITOR"
alias dc='docker compose'
alias g='git'
alias grep='grep --color'
alias lg='lazygit'
alias l='tree -L 1'
alias ll='tree -L 2'
alias lll='tree -L 3'
alias llll='tree -L 4'
alias ls='ls --color=auto'
alias lls='ls --color=auto -al'
alias nv="nvim"
alias nvd="nvim -d"
alias q=exit
alias sudoedit='sudo -e'
alias se='sudo -e'
alias t='tmux'
alias tkill='tmux kill-server'
alias v=view

#------------------------------------------------------------------------------
#-- Functions -----------------------------------------------------------------
#------------------------------------------------------------------------------

fpath=("$ZDOTDIR/functions/common" $fpath)
autoload -Uz $ZDOTDIR/functions/common/*

# Host specific functions, based on hostname
host_fpath="$ZDOTDIR/functions/host/$(hostname -s | tr '[:upper:]' '[:lower:]')"
if [ -d "$host_fpath" ]; then
  fpath=("$host_fpath" $fpath)
  autoload -Uz $host_fpath/*
fi
unset host_fpath

#------------------------------------------------------------------------------
#-- Completion ----------------------------------------------------------------
#------------------------------------------------------------------------------

# zsh-completions
source $ZDOTDIR/plugins/zsh-completions/zsh-completions.plugin.zsh

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
_comp_path="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
setopt EXTENDED_GLOB
if [[ $_comp_path(#qNmh-20) ]]; then
  # -C (skip function check) implies -i (skip security check).
  compinit -C -d "$_comp_path"
else
  mkdir -p "$_comp_path:h"
  compinit -i -d "$_comp_path"
  # Keep $_comp_path younger than cache time even if it isn't regenerated.
  touch "$_comp_path"
fi
unsetopt EXTENDED_GLOB
unset _comp_path

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

zstyle '*'                   single-ignored  show
zstyle ':completion:*'       completer       _complete
zstyle ':completion:*'       insert-tab      pending
zstyle ':completion:*'       list-colors     ${(s.:.)LS_COLORS}
zstyle ':completion:*'       matcher-list    'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*'       menu            select
zstyle ':completion:*'       squeeze-slashes true
zstyle ':completion:*:ssh:*' hosts           off

#------------------------------------------------------------------------------
#-- Prompt --------------------------------------------------------------------
#------------------------------------------------------------------------------

source $ZDOTDIR/plugins/git-prompt.zsh/git-prompt.zsh

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{#4a4e68}%f "
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[white]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[yellow]%}▾"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}▴"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}•"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}•"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}•"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[red]%}#"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}●"
ZSH_GIT_PROMPT_ENABLE_SECONDARY=1
ZSH_THEME_GIT_PROMPT_TAGS_SEPARATOR=", "
ZSH_THEME_GIT_PROMPT_TAGS_PREFIX="%{$fg_bold[black]%}(%f"
ZSH_THEME_GIT_PROMPT_TAGS_SUFFIX="%{$fg_bold[black]%})%f "
ZSH_THEME_GIT_PROMPT_TAG="%{$fg[magenta]%}"
ZSH_GIT_PROMPT_SHOW_STASH=1

() {
  local prompt_char='\$'
  local prompt_color='%{$fg_bold[white]%}'
  local lvl=$SHLVL
  local host_char='%{$fg_bold[green]%}●%f'
  local hostname='%m '

  if [[ "$OSTYPE" == "darwin"* ]]; then
    host_char=''
    hostname=''
  fi

  if [[ $EUID -eq 0 ]]; then
    prompt_char='#'
    prompt_color='%{$fg_bold[red]%}'
  fi

  [ -n "$TMUX" ] && lvl=$(($SHLVL - 1))

  PROMPT=''
  PROMPT+="%F{#25293c}%f%K{#25293c}%{$fg_bold[white]%}${host_char} ${hostname}%f%k"
  PROMPT+='%K{#1f2233}%{$fg_bold[cyan]%} %1~%f%k%F{#1f2233}%f'
  PROMPT+='$(gitprompt)'
  PROMPT+='$(gitprompt_secondary)'
  PROMPT+=$'\n'
  PROMPT+='%{$fg[yellow]%}%(1j. ◆ .)%f'
  PROMPT+='${${VIRTUAL_ENV#0}:+($(basename $VIRTUAL_ENV)) }'
  PROMPT+="${prompt_color}$(printf "$prompt_char%.0s" {1..$lvl})%{$reset_color%} "

  SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "
}

#------------------------------------------------------------------------------
#-- Plugins/Scripts -----------------------------------------------------------
#------------------------------------------------------------------------------

source $ZDOTDIR/plugins/zsh-defer/zsh-defer.plugin.zsh

function bti-defer-load() {
  test -f "$1" && zsh-defer source "$1"
}

bti-defer-load $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
bti-defer-load $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bti-defer-load $ZDOTDIR/plugins/z/z.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  bti-defer-load $XDG_CONFIG_HOME/fzf/fzf.zsh
else
  bti-defer-load /usr/share/fzf/key-bindings.zsh
  bti-defer-load /usr/share/fzf/completion.zsh
fi

unfunction bti-defer-load

function bti-defer-load-after() {
  # zsh-syntax-highlighting
  ZSH_HIGHLIGHT_STYLES[path]="none"
  ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red"

  # zsh-autosuggestions
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=bti-magic-enter
  ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  unfunction bti-defer-load-after
}

zsh-defer -t 0.5 bti-defer-load-after

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
function _fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
function _fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Setup dircolors
() {
  local _dircolors="$XDG_CONFIG_HOME/dircolors/nord.dircolors"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    command -v gdircolors >/dev/null && test -r $_dircolors && eval $(command gdircolors $_dircolors)
  else
    command -v dircolors >/dev/null && test -r $_dircolors && eval $(command dircolors $_dircolors)
  fi
}

#------------------------------------------------------------------------------
#-- Local & Host Specific Options ---------------------------------------------
#------------------------------------------------------------------------------

host_rc="$ZDOTDIR/host/$(hostname -s | tr '[:upper:]' '[:lower:]')"
test -r "$host_rc" && source "$host_rc"
unset host_rc

local_rc="$HOME/.zshrc.local"
test -r "$local_rc" && source "$local_rc"
unset local_rc
