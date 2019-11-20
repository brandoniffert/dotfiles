# Set PATH
typeset -U path

path=(
  $HOME/.zsh/bin
  $HOME/.local/bin
  $HOME/.composer/vendor/bin
  /usr/local/sbin
  $path
)
