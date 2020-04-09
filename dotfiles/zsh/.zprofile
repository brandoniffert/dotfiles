# Exports
source $ZDOTDIR/exports

# Path
path=(
  $HOME/.local/bin
  $ZDOTDIR/bin
  $N_PREFIX/bin
  $PYENV_ROOT/shims
  $RBENV_ROOT/shims
  $XDG_DATA_HOME/composer/vendor/bin
  /usr/local/sbin
  $path
)

# Ensure path arrays do not contain duplicates
typeset -gU cdpath fpath path
