# Exports
source $ZDOTDIR/exports

# Path
path=(
  $ZDOTDIR/bin/common
  $HOME/.local/bin
  /usr/local/sbin
  $path
)

host_bin="$ZDOTDIR/bin/host/$(hostname -s | tr '[:upper:]' '[:lower:]')"
[ -d "$host_bin" ] && path=($host_bin $path)
unset host_bin

# Ensure path arrays do not contain duplicates
typeset -gU cdpath fpath path
