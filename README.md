# dotfiles

brandoniffert's dotfiles — Collected from all over the Internet

## Tools Used

Everything begins with [homebrew](http://mxcl.github.com/homebrew/).

`brew install git zsh rbenv ruby-build wget tmux reattach-to-user-namespace tree htop-osx`

### Vim

I use a homebrew formula for a build of Vim configured with Ruby support.

`brew install https://raw.github.com/gist/3174312/4cf3f4bbb9094984de374086591966a167c3781a/vim.rb`

## Install

There is a Rakefile with an install task to handle setting up symlinks in your home directory: `rake install`
