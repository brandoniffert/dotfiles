#!/usr/bin/env bash
set -euo pipefail

state_dir="$HERDR_PLUGIN_STATE_DIR"
mru_limit=8

event_field() {
  jq -r --arg k "$1" '(.data // .)[$k] // empty' <<<"$HERDR_PLUGIN_EVENT_JSON"
}

case "${1:-}" in
  focused)
    tab="$(event_field tab_id)"
    ws="$(event_field workspace_id)"
    [[ -n "$tab" && -n "$ws" ]] || exit 0
    file="$state_dir/$ws"
    mkdir -p "$state_dir"
    tmp="$(mktemp "$file.XXXXXX")"
    { printf '%s\n' "$tab"; [[ -f "$file" ]] && grep -vxF -e "$tab" -e '' "$file"; } |
      head -n "$mru_limit" >"$tmp" || true
    mv -f "$tmp" "$file"
    ;;
  toggle)
    ws="${HERDR_WORKSPACE_ID:-}"
    file="$state_dir/$ws"
    [[ -n "$ws" && -f "$file" ]] || exit 0
    live="$("$HERDR_BIN_PATH" tab list --workspace "$ws" 2>/dev/null | jq -r '.result.tabs[].tab_id')" || exit 0
    target=""
    while IFS= read -r id; do
      if [[ -n "$id" && "$id" != "${HERDR_TAB_ID:-}" ]] && grep -qxF -e "$id" <<<"$live"; then
        target="$id"
        break
      fi
    done < <(awk 1 "$file")
    [[ -n "$target" ]] || exit 0
    "$HERDR_BIN_PATH" tab focus "$target" >/dev/null || true
    ;;
esac
