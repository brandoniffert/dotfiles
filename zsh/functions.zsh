# Serve a directory on localhost and open in browser
function server() {
  local port="${1:-9876}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer $port
}

# Serve a directory on localhost and open in browser (php)
function pserver() {
  local port="${1:-6789}"
  open "http://localhost:${port}/"
  php -S localhost:$port
}

# Extract archives - use: xtract <file>
# Credits to http://dotfiles.org/~pseup/.bashrc
function xtract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz) tar xzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) rar x $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xf $1 ;;
      *.tbz2) tar xjf $1 ;;
      *.tgz) tar xzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "'$1' cannot be extracted via xtract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Get gzipped size
function gz() {
  echo "orig size    (bytes): "
  cat "$1" | wc -c
  echo "gzipped size (bytes): "
  gzip -c "$1" | wc -c
}

# Get all dig info
function digg() {
  dig +nocmd "$1" any +multiline +noall +answer
}

# Determine size of a file or total size of a directory
function fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* *
  fi
}

# Colorize man pages
function man() {
  LESS_TERMCAP_md=$'\e[01;34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;30m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}

# Shows the most used shell commands.
function history_stat() {
  history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

# Use fzf to quickly get to a project
function p() {
  local ignore='Projects$|sites$'
  cd "$(
    find ~/Projects ~/Projects/vagrant-lemp/sites ~/Projects/vagrant-lemp/sites-available -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf
  )"
}

# Use fzf to quickly get to a note
function n() {
  vi "$(find ~/Dropbox/Notes -maxdepth 1 -type f | fzf)"
}

# Quickly open life journal
function jlife() {
  nvim -c 'silent Goyo | set ft=markdown.journal' ~/Dropbox/Notes/Life.md
}

# Quickly open work journal
function jwork() {
  nvim -c 'silent Goyo | set ft=markdown.journal' ~/Dropbox/Notes/Work.md
}

# Quickly open both life and work journals
function jlogs() {
  nvim -c 'silent Goyo 160 | vsp ~/Dropbox/Notes/Life.md | bufdo setlocal ft=markdown.journal | wincmd h' ~/Dropbox/Notes/Work.md
}

# Use fzf to upgrade installed homebrew package
function brewup {
  brew upgrade $(brew list | fzf)
}

# Open notes dir
function notes() {
  vi ~/Dropbox/Notes
}

# Create a new tmux session and default windows
function tsnew() {
  local SESSION_NAME="$1"

  if [[ ! -z "$TMUX" ]] || [[ ! -z "$TMUX_PANE" ]]; then
    echo 'Already inside a tmux session'
    return 1
  fi

  if [ -z "$SESSION_NAME" ]; then
    echo 'Please provide a session name!'
    return 1
  fi

  tmux -q has-session -t "$SESSION_NAME" > /dev/null 2>&1

  # If session already exists, attach to it
  if [ $? -eq 0 ]; then
    tmux attach-session -t "$SESSION_NAME"
  else
    tmux new-session -d -s "$SESSION_NAME"
    tmux rename-window 'code'
    tmux new-window -n 'server-build'
    tmux split-window -h
    tmux new-window -d -n 'scratch'
    tmux select-window -t 'code'
    tmux attach-session -t "$SESSION_NAME"
  fi
}

# Quickly ssh into docker vm
function dockssh() {
  cd ~/Projects/vagrant-docker && vagrant ssh
}

# Quickly start vagrant fsnotify for docker vm
function dockfs() {
  cd ~/Projects/vagrant-docker && vagrant fsnotify
}
