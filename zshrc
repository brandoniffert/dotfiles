autoload -U compinit && compinit
autoload -U colors && colors

export DOTFILES=$HOME/.dotfiles

#-------------------------------------------------------------------------------
# PATHS
#-------------------------------------------------------------------------------
export PATH="/usr/local/sbin:/usr/local/bin:$HOME/.composer/vendor/bin:$PATH"
export PATH="$DOTFILES/bin:$HOME/.scripts:$PATH"
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
export EDITOR='nvim'
export GREP_OPTIONS="--color"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export LANG='en_US.UTF-8'
export SAVEHIST=$HISTSIZE
export WORDCHARS='*?[]~&;!$%^<>'
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Export from Nord dir_colors
export LS_COLORS='no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:';

# For nvm
export NVM_DIR=~/.nvm

# For fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--color=bg+:#3b4252,pointer:#3b4252'

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
alias ls='gls --color=auto'
alias lls='gls --color=auto -al'
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
# Visual select
zstyle ':completion:*' menu select
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

zsh_completions=/usr/local/share/zsh-completions
if [ -d $zsh_completions ]; then
  fpath=($zsh_completions $fpath)
fi
unset zsh_completions

# make aliased completions work
compdef g=git
compdef t=tmux

#-------------------------------------------------------------------------------
# PROMPT
#-------------------------------------------------------------------------------
autoload -U promptinit; promptinit
prompt pure

#-------------------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------------------
[ -f "$DOTFILES/zsh/functions.zsh" ] && source "$DOTFILES/zsh/functions.zsh"

#-------------------------------------------------------------------------------
# SETUP OTHER SCRIPTS/PROGRAMS
#-------------------------------------------------------------------------------
# Setup rbenv
if type rbenv > /dev/null; then
  eval "$(rbenv init - --no-rehash)"
fi

# Use fasd
if type fasd > /dev/null; then
  eval "$(fasd --init auto)"
fi

# Use .localrc for local options
[ -f "$HOME"/.localrc ] && source "$HOME"/.localrc

# Use zsh syntax highlighting
zsh_syntax_hightlighting="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[ -f "$zsh_syntax_hightlighting" ] && source "$zsh_syntax_hightlighting"
unset zsh_syntax_hightlighting

# Use fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
