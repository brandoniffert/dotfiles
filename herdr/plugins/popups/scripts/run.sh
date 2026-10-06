#!/usr/bin/env bash
set -euo pipefail

ctx_field() { jq -r --arg k "$1" '.[$k] // empty' <<<"${HERDR_PLUGIN_CONTEXT_JSON:-{\}}"; }

HERDR_ACTIVE_PANE_CWD="$(ctx_field focused_pane_cwd)"
HERDR_ACTIVE_PANE_ID="$(ctx_field focused_pane_id)"
export HERDR_ACTIVE_PANE_CWD HERDR_ACTIVE_PANE_ID

cd "${HERDR_ACTIVE_PANE_CWD:-$HOME}" 2>/dev/null || true
exec "$@"
