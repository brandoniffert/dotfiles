export LSCOLORS="Exfxcxdxbxegedabagacad"
export LS_COLORS="di=94:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export CLICOLOR=true
export EDITOR='vim'

export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$DOTFILES/bin:$HOME/.scripts:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# let programs know whether the term bg is light or dark
[[ $ITERM_PROFILE == *"light"* ]] && PROFILE_BG='light' || PROFILE_BG='dark'
export PROFILE_BG
