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
  env \
    LESS_TERMCAP_mb=$(printf "\e[0;31m") \
    LESS_TERMCAP_md=$(printf "\e[0;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[0;37;41m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[0;32m") \
    man "$@"
}

# Shows the most used shell commands.
function history_stat() {
  history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

# Use fzf to quickly get to a project
function p() {
  local ignore='Projects$|sites$|vagrant-lemp$'
  cd "$(
    find ~/Projects ~/Projects/vagrant-lemp/sites -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf
  )"
}

# Use fzf to quickly get to a note
function n() {
  vi "$(find ~/Dropbox/Notes -maxdepth 1 -type f | fzf)"
}

# Use fzf to upgrade installed homebrew package
function brewup {
  brew upgrade $(brew list | fzf)
}

# Open notes dir
function notes() {
  vi ~/Dropbox/Notes
}
