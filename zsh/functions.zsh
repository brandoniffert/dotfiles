# serve a directory on localhost and open in browser
function server() {
  local port="${1:-9876}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer $port
}

# serve a directory on localhost and open in browser (php)
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

# get gzipped size
function gz() {
  echo "orig size    (bytes): "
  cat "$1" | wc -c
  echo "gzipped size (bytes): "
  gzip -c "$1" | wc -c
}

# get all dig info
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

# use selecta to quickly get to a project
function p() {
  cd $(find ~/Projects -maxdepth 1 -type d | selecta) && clear
}

# use selecta to quickly get to a note
function n() {
  vi "$(find ~/Dropbox/Notes -maxdepth 1 -type f | selecta)"
}

# open notes dir
function notes() {
  vi ~/Dropbox/Notes
}
