# Exports
source $ZDOTDIR/exports

# Path
path=(
  $HOME/.local/bin
  $ZDOTDIR/bin
  /usr/local/sbin
  $path
)

# Ensure path arrays do not contain duplicates
typeset -gU cdpath fpath path
