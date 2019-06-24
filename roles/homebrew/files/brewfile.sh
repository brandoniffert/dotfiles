#!/bin/sh

set -e

brew tap homebrew/core

# GNU programs non-existing in macOS
brew install watch
brew install wget

# GNU programs whose BSD counterpart is installed in macOS
brew install binutils
brew install coreutils
brew install diffutils
brew install findutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-which
brew install grep
brew install gzip

# GNU programs existing in macOS which are outdated
brew install bash
brew install less
brew install make

# Custom programs
brew install aspell
brew install awscli
brew install bat
brew install composer
brew install ctags
brew install exiftool
brew install fasd
brew install fd
brew install ffmpeg
brew install fzf
brew install getmail
brew install ghostscript
brew install gifsicle
brew install git
brew install go
brew install htop-osx
brew install httpie
brew install imagemagick@6
brew install jq
brew install libusb-compat
brew install media-info
brew install neovim
brew install nvm
brew install openssl
brew install pandoc
brew install php
brew install pipenv
brew install pstree
brew install python@2
brew install python
brew install rbenv
brew install ripgrep
brew install ruby-build
brew install shellcheck
brew install sqlite
brew install ssh-copy-id
brew install teensy_loader_cli
brew install tig
brew install tldr
brew install tmux
brew install tree
brew install vim
brew install yarn
brew install youtube-dl
brew install zsh
brew install zsh-autosuggestions
brew install zsh-completions
brew install zsh-syntax-highlighting

# Cleanup
brew cleanup

# Setup fzf
"$(brew --prefix)"/opt/fzf/install --xdg --key-bindings --completion --no-update-rc
