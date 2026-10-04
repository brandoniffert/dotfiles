#!/usr/bin/env bash
set -euo pipefail

text="$(jq -r '.selected_text // empty' <<<"$HERDR_PLUGIN_CONTEXT_JSON")"
[[ -n "$text" ]] || exit 0

pane="$(jq -r '.focused_pane_id // empty' <<<"$HERDR_PLUGIN_CONTEXT_JSON")"
pane="${pane:-${HERDR_PANE_ID:-}}"
[[ -n "$pane" ]] || exit 0

shell_pid="$("$HERDR_BIN_PATH" pane process-info --pane "$pane" | jq -r '.result.process_info.shell_pid // empty')"
[[ -n "$shell_pid" ]] || exit 0

# OSC 52 must go through the pane pty: plugins run on the server, herdr forwards it to the client
tty="$(ps -o tty= -p "$shell_pid" | tr -d ' ')"
[[ -n "$tty" && "$tty" != "?" && "$tty" != "??" ]] || exit 0
[[ "$tty" == /* ]] || tty="/dev/$tty"
[[ -w "$tty" ]] || exit 0

clean="$(command -v tmux-clean-copy || echo "$(dirname "$0")/../../../../zsh/bin/common/tmux-clean-copy")"
out="$(printf '%s\n' "$text" | "$clean")"
[[ -n "$out" ]] || exit 0

printf '\e]52;c;%s\a' "$(printf %s "$out" | base64 | tr -d '\n')" >"$tty"
