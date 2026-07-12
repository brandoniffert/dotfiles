# Exports
source $ZDOTDIR/exports
test -r "$ZDOTDIR/exports.private" && source "$ZDOTDIR/exports.private"

# Setup homebrew shellenv (cached: the brew fork costs ~20ms per login shell;
# regenerated when the brew binary's mtime changes, i.e. on brew update)
if [[ -x /opt/homebrew/bin/brew ]]; then
  _brew_env="$XDG_CACHE_HOME/zsh/brew-shellenv.zsh"
  if [[ ! "$_brew_env" -nt /opt/homebrew/bin/brew ]]; then
    mkdir -p "${_brew_env:h}"
    /opt/homebrew/bin/brew shellenv > "$_brew_env"
  fi
  source "$_brew_env"
  unset _brew_env
fi

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
