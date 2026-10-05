# shellcheck shell=bash

mru_limit=8

mru_event_field() {
  jq -r --arg k "$1" '(.data // .)[$k] // empty' <<<"$HERDR_PLUGIN_EVENT_JSON"
}

mru_session_dir() {
  local key="${HERDR_SOCKET_PATH:-default}"
  printf '%s/%s\n' "$HERDR_PLUGIN_STATE_DIR" "${key//\//_}"
}

# flock unavailable on macOS; mkdir is atomic.
_mru_locked() {
  local file="$1" i
  shift
  mkdir -p "$(dirname "$file")"
  for ((i = 0; i < 50; i++)); do
    mkdir "$file.lock" 2>/dev/null && break
    sleep 0.02
  done
  ((i < 50)) || {
    find "$file.lock" -maxdepth 0 -mmin +1 -exec rmdir {} \; 2>/dev/null
    return 0
  }
  (
    tmp=""
    trap 'rm -f "$tmp"; rmdir "$file.lock"' EXIT
    tmp="$(mktemp "$file.XXXXXX")"
    "$@" >"$tmp"
    mv -f "$tmp" "$file"
  )
}

_mru_push() {
  printf '%s\n' "$2"
  [[ -f "$1" ]] || return 0
  grep -vxF -e "$2" -e '' "$1" | head -n "$((mru_limit - 1))" || true
}

_mru_remove() {
  [[ -f "$1" ]] || return 0
  grep -vxF -e "$2" -e '' "$1" || true
}

mru_push() {
  _mru_locked "$1" _mru_push "$1" "$2"
}

mru_remove() {
  [[ -f "$1" ]] || return 0
  _mru_locked "$1" _mru_remove "$1" "$2"
}

mru_pick() {
  [[ -f "$1" ]] || return 0
  grep -vxF -m 1 -e "$2" "$1" || true
}
