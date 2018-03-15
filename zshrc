export DOTFILES=$HOME/.dotfiles

#-------------------------------------------------------------------------------
# PATHS
#-------------------------------------------------------------------------------
export PATH="/usr/local/sbin:/usr/local/bin:$HOME/.composer/vendor/bin:$PATH"
export PATH="$DOTFILES/bin:$HOME/.scripts:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

#-------------------------------------------------------------------------------
# OPTIONS
#-------------------------------------------------------------------------------
setopt autocd              # Auto cd into directory by name
setopt autoparamslash      # Tab completing directory appends a slash
setopt autopushd           # cd automatically pushes old dir onto dir stack
setopt completealiases     # Do not expand aliases before completion finishes
setopt completeinword      # Completion from both ends
setopt correct             # Spell check commands
setopt correctall          # Argument auto-correction
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
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export WORDCHARS='*?[]~&;!$%^<>'
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Setup dircolors
command -v dircolors >/dev/null 2>&1 && [ -f "$HOME"/.dir_colors ] && eval $(dircolors $HOME/.dir_colors)
command -v gdircolors >/dev/null 2>&1 && [ -f "$HOME"/.dir_colors ] && eval $(gdircolors $HOME/.dir_colors)

# For nvm
export NVM_DIR=~/.nvm

# For fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='
  --height 40% --border
  --color=bg+:#2b303b,pointer:#2b303b,border:#2b303b
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

# Allow C-x C-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

#-------------------------------------------------------------------------------
# ALIASES
#-------------------------------------------------------------------------------
alias g='git'
alias grep='grep --color'
alias ls='gls --color=auto'
alias lls='gls --color=auto -al'
alias l='tree -L 1'
alias ll='tree -L 2'
alias lll='tree -L 3'
alias t='tmux -u'
alias tnew='tmux new-session -As'
alias vgs="vagrant global-status"
alias vi="vim"
alias v="vim"
alias nv="nvim"
alias nvd="nvim -d"
alias zr!='source ~/.zshrc'
alias ag="ag --color-match='0;31'"
alias fixterm='echo -e "\e<"; reset; stty sane; tput rs1; clear; echo -e "\033c"'

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
# PROMPT
#-------------------------------------------------------------------------------
SPACESHIP_GIT_SYMBOL=''
SPACESHIP_DIR_PREFIX='%F{black}┌%{%f%} '
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true

autoload -U promptinit
promptinit
prompt spaceship

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL='❯'
SPACESHIP_CHAR_PREFIX='%F{black}└%{%f%} '
SPACESHIP_CHAR_SUFFIX=' '
SPACESHIP_CHAR_COLOR_SUCCESS=white
SPACESHIP_DIR_TRUNC=1
SPACESHIP_DIR_COLOR=black
SPACESHIP_GIT_PREFIX=''
SPACESHIP_GIT_BRANCH_COLOR=cyan
SPACESHIP_GIT_STATUS_PREFIX=' '
SPACESHIP_GIT_STATUS_SUFFIX=''
SPACESHIP_GIT_STATUS_DELETED='-'
SPACESHIP_JOBS_SYMBOL='♦'
SPACESHIP_JOBS_COLOR=yellow
SPACESHIP_EXEC_TIME_PREFIX=''
SPACESHIP_VENV_PREFIX='venv:'
SPACESHIP_VENV_COLOR=8
SPACESHIP_PROMPT_ORDER=(
  dir           # Current directory section
  host          # Hostname section
  jobs          # Backgound jobs indicator
  git           # Git section (git_branch + git_status)
  aws           # Amazon Web Services section
  exec_time     # Execution time
  battery       # Battery level and status
  venv          # virtualenv section
  line_sep      # Line break
  exit_code     # Exit code section
  char          # Prompt character
)

#-------------------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------------------
[ -f "$DOTFILES/zsh/functions.zsh" ] && source "$DOTFILES/zsh/functions.zsh"

# Adds `cdr` command for navigating to recent directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# Enable menu-style completion for cdr
zstyle ':completion:*:*:cdr:*:*' menu selection

# Fall through to cd if cdr is passed a non-recent dir as an argument
zstyle ':chpwd:*' recent-dirs-default true

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

# Setup additonal scripts that vary in location based on distro
function () {
  local -a locations
  local file

  locations=(
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  )

  for file in $locations; do
    [ -f $file ] && source $file
  done
}

ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_HIGHLIGHT_STYLES[path]='none'

# Use fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use .localrc for local options
[ -f "$HOME/.localrc" ] && source "$HOME/.localrc"
