export LSCOLORS="exGxBxDxCxEgEdxbxgxcxd"
export CLICOLOR=true
export EDITOR='vim'

# let programs know whether the term bg is light or dark
[[ $ITERM_PROFILE == *"light"* ]] && PROFILE_BG='light' || PROFILE_BG='dark'
export PROFILE_BG

[[ $PROFILE_BG == "light" ]] && BASE16_SCHEME='solarized' || BASE16_SCHEME='default'
BASE16_SHELL="$HOME/.config/base16-shell/base16-$BASE16_SCHEME.dark.sh"
[[ -s $BASE16_SHELL ]] && . $BASE16_SHELL

