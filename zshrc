autoload -U compinit && compinit
autoload -U colors && colors

export DOTFILES=$HOME/.dotfiles

#-------------------------------------------------------------------------------
# PATHS
#-------------------------------------------------------------------------------
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
export PATH="/usr/local/share/npm/bin:$DOTFILES/bin:$HOME/.scripts:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

#-------------------------------------------------------------------------------
# OPTIONS
#-------------------------------------------------------------------------------
setopt APPEND_HISTORY       # adds history
setopt AUTO_CD              # auto cd into directory by name
setopt COMPLETE_ALIASES     # don't expand aliases before completion finishes
setopt COMPLETE_IN_WORD     # completion from both ends
setopt CORRECT              # spell check commands
setopt EXTENDED_HISTORY     # add timestamps to history
setopt HIST_IGNORE_ALL_DUPS # don't record dupes in history
setopt HIST_IGNORE_SPACE    # don't save commands with leading space to history
setopt HIST_REDUCE_BLANKS   # remove superfluous blanks from history
setopt HIST_VERIFY          # don't auto execute expanded history command
setopt IGNORE_EOF           # don't exit on EOF
setopt INC_APPEND_HISTORY   # adds history incrementally
setopt LOCAL_OPTIONS        # allow functions to have local options
setopt LOCAL_TRAPS          # allow functions to have local traps
setopt NO_BG_NICE           # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt PROMPT_SUBST
setopt SHARE_HISTORY        # share history between sessions

#-------------------------------------------------------------------------------
# EXPORTS
#-------------------------------------------------------------------------------
export CLICOLOR=true
export EDITOR='vim'
export GREP_OPTIONS="--color"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export LANG='en_US.UTF-8'
export LSCOLORS="exfxbxdxcxegedxbxgacac"
export SAVEHIST=$HISTSIZE
export WORDCHARS='*?[]~&;!$%^<>'

# Let programs know whether the term bg is light or dark - default to dark
[[ $ITERM_PROFILE == *"light"* ]] && ITERM_PROFILE_BG='light' || ITERM_PROFILE_BG='dark'
export ITERM_PROFILE_BG

# Set correct FZF color depending on the profile color
[[ $ITERM_PROFILE_BG == 'light' ]] && export FZF_DEFAULT_OPTS='--color=light'

# For nvm
export NVM_DIR=~/.nvm

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
alias lls='ls -al'
alias t='tmux -u'
alias tnew='tmux new-session -As'
alias vgs="vagrant global-status"
alias vi="vim"
alias v="vim"
alias nv="NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim"
alias zr!='source ~/.zshrc'
alias ag="ag --color-match='0;31'"

#-------------------------------------------------------------------------------
# COMPLETION
#-------------------------------------------------------------------------------
# Matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
# Don't autocomplete hosts
zstyle ':completion:*:ssh:*' hosts off
# Color ls completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
git_completion='$(brew --prefix)/share/zsh/site-functions/_git'
[ -f "$git_completion" ] && source "$git_completion"
unset git_completion

# make aliased completions work
compdef g=git
compdef t=tmux

#-------------------------------------------------------------------------------
# PROMPT
#-------------------------------------------------------------------------------
[ -f "$DOTFILES/zsh/prompt.zsh" ] && source "$DOTFILES/zsh/prompt.zsh"

#-------------------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------------------
[ -f "$DOTFILES/zsh/functions.zsh" ] && source "$DOTFILES/zsh/functions.zsh"

#-------------------------------------------------------------------------------
# SETUP OTHER SCRIPTS/PROGRAMS
#-------------------------------------------------------------------------------
# Setup rbenv
eval "$(rbenv init - --no-rehash)"

# Source tmuxinator completions
[ -f "$DOTFILES"/zsh/completions/tmuxinator.zsh ] &&
  source "$DOTFILES"/zsh/completions/tmuxinator.zsh

# Use .localrc for local options
[ -f "$HOME"/.localrc ] && source "$HOME"/.localrc

# Use zsh syntax highlighting
[ -f `brew --prefix`/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
  source `brew --prefix`/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Use fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use fasd
eval "$(fasd --init auto)"
