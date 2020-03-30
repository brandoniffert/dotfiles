# Language
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG
# See: https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share

# Manually manage XDG for some programs
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export COMPOSER_HOME="$XDG_DATA_HOME"/composer
export GEM_HOME="$XDG_DATA_HOME"/gem
export GEM_SPEC_CACHE="$XDG_CACHE_HOME"/gem
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node/repl_history
export npm_config_userconfig="$XDG_CONFIG_HOME"/npm/config
export npm_config_prefix="$XDG_DATA_HOME"/npm
export npm_config_cache="$XDG_CACHE_HOME"/npm
export npm_config_devdir="$XDG_CACHE_HOME"/node-gyp
export PYENV_ROOT="$XDG_DATA_HOME"/pyenv
export RBENV_ROOT="$XDG_DATA_HOME"/rbenv
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME"/ripgrep/config
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export SQLITE_HISTORY="$XDG_DATA_HOME"/sqlite_history
export SUBVERSION_HOME="$XDG_CONFIG_HOME"/subversion
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export VAGRANT_HOME="$XDG_DATA_HOME"/vagrant
export VAGRANT_ALIAS_FILE="$XDG_DATA_HOME"/vagrant/aliases
export _Z_DATA="$XDG_DATA_HOME"/z

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh

# Misc
export EDITOR=nvim
export LESSHISTFILE=-

# PATH
path=(
  "$ZDOTDIR"/bin
  "$HOME"/.local/bin
  "$XDG_DATA_HOME"/composer/vendor/bin
  /usr/local/sbin
  "$path"
)

# Ensure path arrays do not contain duplicates
typeset -gU cdpath fpath mailpath path
