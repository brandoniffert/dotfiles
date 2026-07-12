# Read via the ~/.zshenv symlink by first shells (no ZDOTDIR in env yet) and
# directly as $ZDOTDIR/.zshenv by shells that inherit ZDOTDIR (tmux panes,
# nested shells) -- keep contents idempotent
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Host config layers to try, in order: iffystudio/iffyair share an "iffy"
# layer, then the actual short hostname (lowercased)
bti_host="${(L)HOST%%.*}"
bti_host_layers=(${${(M)bti_host:#iffy(studio|air)*}:+iffy} $bti_host)

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
