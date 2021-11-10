#------------------------------------------------------------------------------
#-- Options -------------------------------------------------------------------
#------------------------------------------------------------------------------

setopt AUTO_CD              # Auto cd into directory by name
setopt AUTO_PARAM_SLASH     # Tab completing directory appends a slash
setopt AUTO_PUSHD           # cd automatically pushes old dir onto dir stack
setopt COMPLETE_ALIASES     # Do not expand aliases before completion finishes
setopt COMPLETE_IN_WORD     # Completion from both ends
setopt CORRECT              # Spell check commands
setopt EXTENDED_GLOB        # Use additional special characters in globbing
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
export BAT_THEME=Nord
export HOMEBREW_NO_ANALYTICS=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export EDITOR=nvim
export PAGER=less
export LESSHISTFILE=-

# Filename (if known), line number if known, falling back to percent if known,
# falling back to byte offset, falling back to dash
export LESSPROMPT='?f%f .?ltLine %lt:?pt%pt\%:?btByte %bt:-...'

# i = case-insensitive searches, unless uppercase characters in search string
# F = exit immediately if output fits on one screen
# M = verbose prompt
# R = ANSI color support
# S = chop long lines (rather than wrap them onto next line)
# X = suppress alternate screen
export LESS=iFMRSX

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\e[01;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;43;30m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[04;37m'

# For fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
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
alias g='git'
alias grep='grep --color'
alias lg='lazygit'
alias l='tree -L 1'
alias ll='tree -L 2'
alias lll='tree -L 3'
alias llll='tree -L 4'
alias nv="nvim"
alias nvd="nvim -d"
alias q=exit
alias sudoedit='sudo -e'
alias se='sudo -e'
alias t='tmux'
alias tkill='tmux kill-server'
alias v=view

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ap='ansible-playbook'
  alias ls='gls --color=auto'
  alias lls='gls --color=auto -al'
  alias vgs="vagrant global-status"
else
  alias ls='ls --color=auto'
  alias lls='ls --color=auto -al'
fi

#------------------------------------------------------------------------------
#-- Functions -----------------------------------------------------------------
#------------------------------------------------------------------------------

fpath=("$ZDOTDIR/functions" $fpath)
autoload -Uz $ZDOTDIR/functions/*

#------------------------------------------------------------------------------
#-- Completion ----------------------------------------------------------------
#------------------------------------------------------------------------------

zstyle '*'                   single-ignored  show
zstyle ':completion:*'       completer       _complete
zstyle ':completion:*'       insert-tab      pending
zstyle ':completion:*'       list-colors     ${(s.:.)LS_COLORS}
zstyle ':completion:*'       matcher-list    'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*'       menu            select
zstyle ':completion:*'       squeeze-slashes true
zstyle ':completion:*:ssh:*' hosts           off

# zsh-completions
source $ZDOTDIR/plugins/zsh-completions/zsh-completions.plugin.zsh

() {
  emulate -L zsh
  local -r cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
  local -r zcd=$cache_dir/.zcompdump
  local -r zcdc="$zcd.zwc"

  # Store completion cache
  # https://www.reddit.com/r/zsh/comments/fqpidr/removing_zcompdump_file_creation/
  autoload -Uz _store_cache compinit
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' cache-path $cache_dir/.zcompcache
  [[ -f $cache_dir/.zcompcache/.make-cache-dir ]] || _store_cache .make-cache-dir

  # Perform compinit only once a day
  # https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2894219
  if [[ -f "$zcd"(#qN.m+1) ]]; then
    compinit -i -d "$zcd"
    { rm -f "$zcdc" && zcompile "$zcd" } &!
  else
    compinit -C -d "$zcd"
    { [[ ! -f "$zcdc" || "$zcd" -nt "$zcdc" ]] && rm -f "$zcdc" && zcompile "$zcd" } &!
  fi
}

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
  local PROMPT_CHAR='\$'
  local PROMPT_COLOR='%{$fg_bold[white]%}'
  local LVL=$SHLVL
  local HOST_CHAR='%{$fg_bold[green]%}●%f'

  if [[ "$OSTYPE" == "darwin"* ]]; then
    HOST_CHAR=''
  fi

  if [[ $EUID -eq 0 ]]; then
    PROMPT_CHAR='#'
    PROMPT_COLOR='%{$fg_bold[red]%}'
  fi

  [ -n "$TMUX" ] && LVL=$(($SHLVL - 1))

  PROMPT=''
  PROMPT+="%F{#25293c}%f%K{#25293c}%{$fg_bold[white]%}${HOST_CHAR} %m %f%k"
  PROMPT+='%K{#1d202f}%{$fg_bold[cyan]%} %1~%f%k%F{#1d202f}%f'
  PROMPT+='$(gitprompt)'
  PROMPT+='$(gitprompt_secondary)'
  PROMPT+=$'\n'
  PROMPT+='%{$fg[yellow]%}%(1j. ◆ .)%f'
  PROMPT+='${${VIRTUAL_ENV#0}:+($(basename $VIRTUAL_ENV)) }'
  PROMPT+="${PROMPT_COLOR}$(printf "$PROMPT_CHAR%.0s" {1..$LVL})%{$reset_color%} "

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

# pyenv (lazy loaded)
if command -v pyenv &>/dev/null; then
  pyenv() {
    eval "$(command pyenv init - --no-rehash)"
    pyenv "$@"
    typeset -U path
  }
fi

# rbenv (lazy loaded)
if command -v rbenv &>/dev/null; then
  rbenv() {
    eval "$(command rbenv init - --no-rehash)"
    command rbenv "$@"
    typeset -U path
  }
fi

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
#-- Local Options -------------------------------------------------------------
#------------------------------------------------------------------------------

[ -r ~/.zshrc.local ] && source ~/.zshrc.local
