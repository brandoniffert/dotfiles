# Serve a directory on localhost and open in browser
function server() {
  local port="${1:-9876}"
  open "http://localhost:${port}/"
  python -m http.server $port
}

# Serve a directory on localhost and open in browser (php)
function pserver() {
  local port="${1:-6789}"
  open "http://localhost:${port}/"
  php -S localhost:$port
}

# Get gzipped size
function gz() {
  echo "orig size    (bytes): "
  cat "$1" | wc -c
  echo "gzipped size (bytes): "
  gzip -c "$1" | wc -c
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
  LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\e[01;34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;43;30m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[04;37m' \
  command man "$@"
}

# Shows the most used shell commands.
function histstat() {
  history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

# Use fzf to quickly get to a project
function p() {
  local ignore='Projects$|Work$|Life$'
  cd "$(
    find ~/Projects/Work ~/Projects/Life -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf --header='Projects'
  )" && clear
}

function pw() {
  local ignore='Projects\/Work$'
  cd "$(
    find ~/Projects/Work -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf --header='Projects (Work)'
  )" && clear
}

function pl() {
  local ignore='Projects\/Life$'
  cd "$(
    find ~/Projects/Life -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf --header='Projects (Life)'
  )" && clear
}

function pa() {
  local ignore='Projects\/Archive$'
  cd "$(
    find ~/Projects/Archive -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf --header='Projects (Archive)'
  )" && clear
}

# Use fzf to quickly get to a note
function n() {
  $EDITOR "$(find $HOME/Dropbox/Notes -maxdepth 1 -type f | fzf)"
}

# Use fzf to upgrade installed homebrew package
function brewup() {
  brew update
  local choices=$(brew outdated -v | fzf -m --reverse --preview="echo {} | cut -d' ' -f1 | xargs brew info")
  [[ ! -z "$choices" ]] && echo "$choices" | cut -d' ' -f1 | xargs brew upgrade
}

# Browse Chrome history
function bhist() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

# Quickly manage vagrant homestead from anywhere
function hst() {
  if [ $# -eq 0 ]; then
    cd "$HOME/Projects/Tooling/vagrant-homestead" && clear
  else
    ( cd "$HOME/Projects/Tooling/vagrant-homestead" && vagrant $* && write-vagrant-global-status )
  fi
}

# Pass-through vagrant commands and write-vagrant-global-status
function vg() {
  vagrant $* && write-vagrant-global-status
}

# ts [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function ts() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

# Create a new tmux session and attach to it
# If the session already exists, attach to that one
function tnew() {
  local session_name="$1"
  local working_dir=${2:-$HOME}

  if [ -z "$session_name" ]; then
    echo 'Please provide a session name!'
    return 1
  fi

  # Check for existing session
  tmux -q has-session -t "$session_name" > /dev/null 2>&1

  # If session doesn't exist, create it
  if [ $? -ne 0 ]; then
    tmux new-session -c "$working_dir" -d -s "$session_name"
  fi

  clear

  # Attach or switch to it, depending on whether we are already in a tmux session
  if [[ ! -z "$TMUX" ]] || [[ ! -z "$TMUX_PANE" ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

# Create a new tmux session within a project folder and attach to it
# If the session already exists, attach to that one
function tnewp() {
  local ignore='Projects$|Work$|Life$'
  local project_dir="$(
    find ~/Projects/Work ~/Projects/Life -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf --header='Projects'
  )"

  local session_name=$(basename "$project_dir" | sed 's/\./-/g')

  if [ -z "$session_name" ]; then
    return 1
  fi

  # Check for existing session
  tmux -q has-session -t "$session_name" > /dev/null 2>&1

  # If session doesn't exist, create it
  if [ $? -ne 0 ]; then
    tmux new-session -c "$project_dir" -d -s "$session_name"
  fi

  clear

  # Attach or switch to it, depending on whether we are already in a tmux session
  if [[ ! -z "$TMUX" ]] || [[ ! -z "$TMUX_PANE" ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

# Setup two windows in a tmux session
function tup() {
  if [[ ! -z "$TMUX" ]] || [[ ! -z "$TMUX_PANE" ]]; then
    if [[ $(tmux list-windows | grep '' -c) -eq 1 ]]; then
      tmux rename-window 'code'
      tmux new-window
      tmux rename-window 'build'
      tmux select-window -t 1
      clear
    fi
  fi
}

# Allow Ctrl-z to toggle between suspend and resume
function Resume {
  fg
  zle push-input
  BUFFER=""
  zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

# Don't send tmux TERM when using ssh
function ssh() {
  emulate -L zsh

  local LOCAL_TERM=$(echo -n "$TERM" | sed -e s/tmux/screen/)
  env TERM=$LOCAL_TERM command ssh "$@"
}

# Create a scratch shell and directory
function scratch() {
  local SCRATCH=$(mktemp -d)
  echo 'Spawing subshell in scratch directory:'
  echo "  $SCRATCH"
  (cd $SCRATCH; zsh)
  echo "Removing scratch directory"
  rm -r "$SCRATCH"
}

function ssh() {
  emulate -L zsh

  env TERM=xterm-256color command ssh "$@"
}

# Print information about a remote SSL certificate
# Based on: https://serverfault.com/a/661982/219567
function ssl() {
  emulate -L zsh

  if [ $# -ne 1 ]; then
    echo "error: a host argument is required"
    return 1
  fi

  local REMOTE=$1

  echo | openssl s_client -showcerts -servername "$REMOTE" -connect "$REMOTE:443" 2>/dev/null | openssl x509 -inform pem -noout -text
}
