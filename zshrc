autoload -U compinit && compinit

export DOTFILES=$HOME/.dotfiles

#------------------------------------------------------------------------------
# PATHS
#------------------------------------------------------------------------------
export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
export PATH="/usr/local/share/npm/bin:$DOTFILES/bin:$HOME/.scripts:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

#------------------------------------------------------------------------------
# OPTIONS
#------------------------------------------------------------------------------
setopt NO_BG_NICE           # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS        # allow functions to have local options
setopt LOCAL_TRAPS          # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY        # share history between sessions ???
setopt EXTENDED_HISTORY     # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT              # spell check commands
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt APPEND_HISTORY       # adds history
setopt INC_APPEND_HISTORY   # adds history incrementally
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS # don't record dupes in history
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt COMPLETE_ALIASES     # don't expand aliases before completion finishes

#------------------------------------------------------------------------------
# EXPORTS
#------------------------------------------------------------------------------
export LSCOLORS="exgxBxDxCxEgEdxbxgxcxd"
export CLICOLOR=true
export GREP_OPTIONS="--color"

export EDITOR='vim'

export WORDCHARS='*?[]~&;!$%^<>'

export HISTSIZE=100000
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=$HISTSIZE

# let programs know whether the term bg is light or dark - default to dark
[[ $ITERM_PROFILE == *"light"* ]] && PROFILE_BG='light' || PROFILE_BG='dark'
export PROFILE_BG

# a lot of config for setting up base16 - relies on iterm2 profile name
if [[ $ITERM_PROFILE == *"base16"* || $TERM_PROGRAM == 'Apple_Terminal' ]]; then
  BASE16_THEME='tomorrow'
  [[ $PROFILE_BG == 'light' ]] && THEME_STYLE='light' || THEME_STYLE='dark'
  BASE16_CONF="$HOME/.config/base16-shell/base16-$BASE16_THEME.$THEME_STYLE.sh"
  [[ -s $BASE16_CONF ]] && source $BASE16_CONF
fi

#------------------------------------------------------------------------------
# KEYS
#------------------------------------------------------------------------------
# use emacs key bindings
bindkey -e

# make search up and down work
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# also do history expansion on space
bindkey ' ' magic-space

bindkey "^K" kill-whole-line                    
bindkey "^R" history-incremental-search-backward
bindkey "^A" beginning-of-line                  
bindkey "^E" end-of-line                        
bindkey "^D" delete-char                        
bindkey "^F" forward-char                       
bindkey "^B" backward-char                      

# allow C-x C-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

#------------------------------------------------------------------------------
# ALIASES
#------------------------------------------------------------------------------
alias g='git'
alias t='tmux -u'
alias vi="vim"
alias j="z"
alias zr!='source ~/.zshrc'

#------------------------------------------------------------------------------
# COMPLETION
#------------------------------------------------------------------------------
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
# don't autocomplete hosts
zstyle ':completion:*:ssh:*' hosts off
# color ls completion
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

#------------------------------------------------------------------------------
# PROMPT
#------------------------------------------------------------------------------
[ -f "$DOTFILES/zsh/prompt.zsh" ] && source "$DOTFILES/zsh/prompt.zsh"

#------------------------------------------------------------------------------
# FUNCTIONS
#------------------------------------------------------------------------------
[ -f "$DOTFILES/zsh/functions.zsh" ] && source "$DOTFILES/zsh/functions.zsh"

#------------------------------------------------------------------------------
# SETUP OTHER SCRIPTS/PROGRAMS
#------------------------------------------------------------------------------
# setup rbenv
eval "$(rbenv init - --no-rehash)"

# source z.sh script
[ -f `brew --prefix`/etc/profile.d/z.sh ] && source `brew --prefix`/etc/profile.d/z.sh

# use .localrc for local options
[ -f "$HOME"/.localrc ] && source "$HOME"/.localrc
