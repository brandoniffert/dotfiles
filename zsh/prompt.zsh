source "$DOTFILES/zsh/git-super-status.zsh"

function prompt_divider() {
  echo "\x1b[38;2;49;53;69m$(repeat $COLUMNS printf "%s" "—")\x1b[0m"
}

function prompt_virtualenv() {
  [[ ! -z "$VIRTUAL_ENV" ]] && echo -n "(`basename \"$VIRTUAL_ENV\"`) "
}

function prompt_jobs() {
  echo -n "%F{7}%(1j.%j .)%f"
}

function prompt_dir() {
  echo -n '%F{cyan}%c%f'
}

function prompt_marker() {
  echo -n " %F{yellow}%(!.#.❯) %f"
}

function prompt_vagrant_status() {
  local running="$(cat ~/.vagrant-global-status 2> /dev/null)"
  [ -n "$running" ] && echo -n "%F{7}[$running]%f"
}

function build_prompt() {
  prompt_divider
  prompt_virtualenv
  prompt_jobs
  prompt_dir
  git_super_status
  prompt_marker
}

PROMPT='$(build_prompt)'
RPROMPT='$(prompt_vagrant_status)'
