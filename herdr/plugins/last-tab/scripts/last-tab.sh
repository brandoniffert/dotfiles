#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=SCRIPTDIR/../../lib/mru.sh
. "$HERDR_PLUGIN_ROOT/../lib/mru.sh"

case "${1:-}" in
  focused | closed)
    tab="$(mru_event_field tab_id)"
    ws="$(mru_event_field workspace_id)"
    [[ -n "$tab" && -n "$ws" ]] || exit 0
    file="$(mru_session_dir)/$ws"
    if [[ "$1" == focused ]]; then
      mru_push "$file" "$tab"
    else
      mru_remove "$file" "$tab"
    fi
    ;;
  workspace-closed)
    ws="$(mru_event_field workspace_id)"
    [[ -n "$ws" ]] || exit 0
    rm -f "$(mru_session_dir)/$ws"
    ;;
  toggle)
    ws="${HERDR_WORKSPACE_ID:-}"
    [[ -n "$ws" ]] || exit 0
    target="$(mru_pick "$(mru_session_dir)/$ws" "${HERDR_TAB_ID:-}")"
    [[ -n "$target" ]] || exit 0
    "$HERDR_BIN_PATH" tab focus "$target" >/dev/null || true
    ;;
esac
