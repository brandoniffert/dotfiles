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

# Extract archives
function extract() {
  local remove_archive
  local success
  local extract_dir

  if (( $# == 0 )); then
    cat <<-'EOF' >&2
Usage: extract [-option] [file ...]
Options:
    -r, --remove    Remove archive after unpacking.
EOF
  fi

  remove_archive=1
  if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
    remove_archive=0
    shift
  fi

  while (( $# > 0 )); do
    if [[ ! -f "$1" ]]; then
      echo "extract: '$1' is not a valid file" >&2
      shift
      continue
    fi

    success=0
    extract_dir="${1:t:r}"
    case "${1:l}" in
      (*.tar.gz|*.tgz) (( $+commands[pigz] )) && { pigz -dc "$1" | tar xv } || tar zxvf "$1" ;;
      (*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
      (*.tar.xz|*.txz)
        tar --xz --help &> /dev/null \
        && tar --xz -xvf "$1" \
        || xzcat "$1" | tar xvf - ;;
      (*.tar.zma|*.tlz)
        tar --lzma --help &> /dev/null \
        && tar --lzma -xvf "$1" \
        || lzcat "$1" | tar xvf - ;;
      (*.tar) tar xvf "$1" ;;
      (*.gz) (( $+commands[pigz] )) && pigz -d "$1" || gunzip "$1" ;;
      (*.bz2) bunzip2 "$1" ;;
      (*.xz) unxz "$1" ;;
      (*.lzma) unlzma "$1" ;;
      (*.z) uncompress "$1" ;;
      (*.zip|*.war|*.jar|*.sublime-package|*.ipsw|*.xpi|*.apk|*.whl) unzip "$1" -d $extract_dir ;;
      (*.rar) unrar x -ad "$1" ;;
      (*.7z) 7za x "$1" ;;
      (*.deb)
        mkdir -p "$extract_dir/control"
        mkdir -p "$extract_dir/data"
        cd "$extract_dir"; ar vx "../${1}" > /dev/null
        cd control; tar xzvf ../control.tar.gz
        cd ../data; extract ../data.tar.*
        cd ..; rm *.tar.* debian-binary
        cd ..
      ;;
      (*)
        echo "extract: '$1' cannot be extracted" >&2
        success=1
      ;;
    esac

    (( success = $success > 0 ? $success : $? ))
    (( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
    shift
  done
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
  LESS_TERMCAP_md=$'\e[01;34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;30m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
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
  )"
  clear
}

function pw() {
  local ignore='Projects\/Work$'
  cd "$(
    find ~/Projects/Work -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf --header='Projects (Work)'
  )"
  clear
}

function pl() {
  local ignore='Projects\/Life$'
  cd "$(
    find ~/Projects/Life -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf --header='Projects (Life)'
  )"
  clear
}

function pa() {
  local ignore='Projects\/Archive$'
  cd "$(
    find ~/Projects/Archive -maxdepth 1 -type d |
    grep -Ev $ignore |
    fzf --header='Projects (Archive)'
  )"
  clear
}

# Use fzf to quickly get to a note
function n() {
  $EDITOR "$(find $HOME/Dropbox/Notes -maxdepth 1 -type f | fzf)"
}

# Quickly open life journal
function jlife() {
  $EDITOR -c 'set ft=markdown.journal | Goyo' ~/Dropbox/Notes/Life.md
}

# Quickly open work journal
function jwork() {
  $EDITOR -c 'set ft=markdown.journal | Goyo' ~/Dropbox/Notes/Work.md
}

# Quickly open both life and work journals
function jlogs() {
  $EDITOR -c 'silent Goyo 160 | vsp ~/Dropbox/Notes/Life.md | bufdo setlocal ft=markdown.journal | wincmd h' ~/Dropbox/Notes/Work.md
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
    cd "$HOME/Projects/vagrant-homestead"
    clear
  else
    ( cd "$HOME/Projects/vagrant-homestead" && vagrant $* && write-vagrant-global-status )
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

  # Attach or switch to it, depending on whether we are already in a tmux session
  if [[ ! -z "$TMUX" ]] || [[ ! -z "$TMUX_PANE" ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
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
