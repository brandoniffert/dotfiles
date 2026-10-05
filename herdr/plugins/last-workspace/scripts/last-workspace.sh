#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=SCRIPTDIR/../../lib/mru.sh
. "$HERDR_PLUGIN_ROOT/../lib/mru.sh"

file="$(mru_session_dir)/mru"

case "${1:-}" in
  focused | closed)
    ws="$(mru_event_field workspace_id)"
    [[ -n "$ws" ]] || exit 0
    if [[ "$1" == focused ]]; then
      mru_push "$file" "$ws"
    else
      mru_remove "$file" "$ws"
    fi
    ;;
  toggle)
    target="$(mru_pick "$file" "${HERDR_WORKSPACE_ID:-}")"
    [[ -n "$target" ]] || exit 0
    "$HERDR_BIN_PATH" workspace focus "$target" >/dev/null || true
    ;;
esac
