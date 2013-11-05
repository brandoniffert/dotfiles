export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export CLICOLOR=true
export EDITOR='vim'

export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$DOTFILES/bin:$HOME/.scripts:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# let programs know whether the term bg is light or dark
[[ $ITERM_PROFILE == *"light"* ]] && PROFILE_BG='light' || PROFILE_BG='dark'
export PROFILE_BG
