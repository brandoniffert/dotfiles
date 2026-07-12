# Exports
source $ZDOTDIR/exports
test -r "$ZDOTDIR/exports.private" && source "$ZDOTDIR/exports.private"

# Setup homebrew shellenv
test -x "/opt/homebrew/bin/brew" && eval "$(/opt/homebrew/bin/brew shellenv)"

# brew shellenv exports FPATH; un-export so nested shells don't inherit a
# pre-populated fpath (masks compinit ordering bugs, churns .zcompdump)
typeset +x FPATH

# Path
path=(
  ${MISE_DATA_DIR:-$XDG_DATA_HOME/mise}/shims
  $ZDOTDIR/bin/common
  $HOME/.local/bin
  $COMPOSER_HOME/vendor/bin
  /usr/local/sbin
  $path
  $CARGO_HOME/bin
)

# Add host-specific bin dirs to PATH
for _bin in $ZDOTDIR/bin/host/${^bti_host_layers}; do
  [ -d "$_bin" ] && path=($_bin $path)
done
unset _bin

# Ensure path arrays do not contain duplicates
typeset -gU cdpath fpath path
