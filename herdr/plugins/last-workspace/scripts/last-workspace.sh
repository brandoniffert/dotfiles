#!/usr/bin/env bash
set -euo pipefail

state_dir="$HERDR_PLUGIN_STATE_DIR"
file="$state_dir/mru"
mru_limit=8

event_field() {
  jq -r --arg k "$1" '(.data // .)[$k] // empty' <<<"$HERDR_PLUGIN_EVENT_JSON"
}

case "${1:-}" in
  focused)
    ws="$(event_field workspace_id)"
    [[ -n "$ws" ]] || exit 0
    mkdir -p "$state_dir"
    tmp="$(mktemp "$file.XXXXXX")"
    { printf '%s\n' "$ws"; [[ -f "$file" ]] && grep -vxF -e "$ws" -e '' "$file"; } |
      head -n "$mru_limit" >"$tmp" || true
    mv -f "$tmp" "$file"
    ;;
  toggle)
    [[ -f "$file" ]] || exit 0
    live="$("$HERDR_BIN_PATH" workspace list 2>/dev/null | jq -r '.result.workspaces[].workspace_id')" || exit 0
    target=""
    while IFS= read -r id; do
      if [[ -n "$id" && "$id" != "${HERDR_WORKSPACE_ID:-}" ]] && grep -qxF -e "$id" <<<"$live"; then
        target="$id"
        break
      fi
    done < <(awk 1 "$file")
    [[ -n "$target" ]] || exit 0
    "$HERDR_BIN_PATH" workspace focus "$target" >/dev/null || true
    ;;
esac
