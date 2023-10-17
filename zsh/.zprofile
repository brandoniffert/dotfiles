# Exports
source $ZDOTDIR/exports
test -r "$ZDOTDIR/exports.private" && source "$ZDOTDIR/exports.private"

# Setup homebrew shellenv
test -x "/opt/homebrew/bin/brew" && eval "$(/opt/homebrew/bin/brew shellenv)"

# Path
path=(
  $ZDOTDIR/bin/common
  $HOME/.local/bin
  $COMPOSER_HOME/vendor/bin
  /usr/local/sbin
  $path
  $CARGO_HOME/bin
)

iffy_bin="$ZDOTDIR/bin/host/iffy"
if [[ $(hostname -s) =~ ^iffy(mac|book|studio|air) ]]; then
  [ -d "$iffy_bin" ] && path=($iffy_bin $path)
fi
unset iffy_bin

host_bin="$ZDOTDIR/bin/host/$(hostname -s | tr '[:upper:]' '[:lower:]')"
[ -d "$host_bin" ] && path=($host_bin $path)
unset host_bin

# Ensure path arrays do not contain duplicates
typeset -gU cdpath fpath path
