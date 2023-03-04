#------------------------------------------------------------------------------
#-- Local & Host Specific Startup ---------------------------------------------
#------------------------------------------------------------------------------
iffy_rc="$ZDOTDIR/host/iffy-startup"
if [[ $(hostname -s) =~ ^iffy(mac|book) ]]; then
  test -r "$iffy_rc" && source "$iffy_rc"
fi
unset iffy_rc

host_rc="$ZDOTDIR/host/$(hostname -s | tr '[:upper:]' '[:lower:]')-startup"
test -r "$host_rc" && source "$host_rc"
unset host_rc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#------------------------------------------------------------------------------
#-- Options -------------------------------------------------------------------
#------------------------------------------------------------------------------

setopt AUTO_CD              # Auto cd into directory by name
setopt AUTO_PARAM_SLASH     # Tab completing directory appends a slash
setopt AUTO_PUSHD           # cd automatically pushes old dir onto dir stack
setopt COMBINING_CHARS      # Combine zero-length punc chars (accents) with base
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
export HISTSIZE=120000
export SAVEHIST=100000
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
alias dce='docker compose exec'
alias dcr='docker compose restart'
alias dcu='docker compose pull && docker compose up -d --force-recreate'
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

common_fpath="$ZDOTDIR/functions/common"
if [ -n "$(ls -A $common_fpath 2>/dev/null)" ]; then
  fpath=("$common_fpath" $fpath)
  autoload -Uz $common_fpath/*
fi

# Host specific functions, based on hostname
iffy_fpath="$ZDOTDIR/functions/host/iffy"
if [[ $(hostname -s) =~ ^iffy(mac|book) ]]; then
  if [ -n "$(ls -A $iffy_fpath 2>/dev/null)" ]; then
    fpath=("$iffy_fpath" $fpath)
    autoload -Uz $iffy_fpath/*
  fi
fi
unset iffy_fpath

host_fpath="$ZDOTDIR/functions/host/$(hostname -s | tr '[:upper:]' '[:lower:]')"
if [ -n "$(ls -A $host_fpath 2>/dev/null)" ]; then
  fpath=("$host_fpath" $fpath)
  autoload -Uz $host_fpath/*
fi
unset host_fpath

#------------------------------------------------------------------------------
#-- Completion ----------------------------------------------------------------
#------------------------------------------------------------------------------

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

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

# Disable completion of users
zstyle ':completion:*' users

# Only use Host value for ssh completion
if [[ -r "$HOME/.ssh/config" ]]; then
  zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts ${${${(@M)${(f)"$(cat $HOME/.ssh/config)"}:#Host *}#Host }:#*[*?]*}
  zstyle ':completion:*:(ssh|scp|ftp|sftp):argument-1:*' tag-order hosts
fi

#------------------------------------------------------------------------------
#-- Plugins/Scripts -----------------------------------------------------------
#------------------------------------------------------------------------------

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit wait lucid light-mode for \
  marlonrichert/zsh-hist \
  rupa/z \
  atload"zicompinit; zicdreplay" blockf \
    zsh-users/zsh-completions \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zsh-users/zsh-syntax-highlighting \
  compile'{src/*.zsh,src/strategies/*}' atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=bti-magic-enter
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

[[ -r "$ZDOTDIR/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh" ]] &&
  source "$ZDOTDIR/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"

if [[ "$OSTYPE" == "darwin"* ]]; then
  source "${XDG_CONFIG_HOME}/fzf/fzf.zsh"
else
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
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
  local _dircolors="$XDG_CONFIG_HOME/dircolors/dircolors"
  [[ "$OSTYPE" == "darwin"* ]] && local dircolors_cmd='gdircolors' || local dircolors_cmd='dircolors'
  command -v "$dircolors_cmd" >/dev/null && test -r $_dircolors && eval $(command $dircolors_cmd $_dircolors)
}

[ -d /opt/homebrew/share/zsh/site-functions ] &&
  fpath=("/opt/homebrew/share/zsh/site-functions" $fpath)

#------------------------------------------------------------------------------
#-- Local & Host Specific Options ---------------------------------------------
#------------------------------------------------------------------------------

iffy_rc="$ZDOTDIR/host/iffy"
if [[ $(hostname -s) =~ ^iffy(mac|book) ]]; then
  test -r "$iffy_rc" && source "$iffy_rc"
fi
unset iffy_rc

host_rc="$ZDOTDIR/host/$(hostname -s | tr '[:upper:]' '[:lower:]')"
test -r "$host_rc" && source "$host_rc"
unset host_rc

local_rc="$HOME/.zshrc.local"
test -r "$local_rc" && source "$local_rc"
unset local_rc

#------------------------------------------------------------------------------
#-- Prompt --------------------------------------------------------------------
#------------------------------------------------------------------------------

SPROMPT="zsh: correct %F{red}'%R'%f to %F{green}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"
