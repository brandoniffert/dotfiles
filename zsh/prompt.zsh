autoload -Uz vcs_info

# Setup git
zstyle ':vcs_info:*' enable git

# Git info styles
zstyle ':vcs_info:git*' unstagedstr '%F{red}●%f'
zstyle ':vcs_info:git*' stagedstr '%F{green}●%f'
zstyle ':vcs_info:git*' formats '%F{7}(%b%u%c%m%F{7})%f'
zstyle ':vcs_info:git*' actionformats '%F{7}(%b%u%c%m:%F{green}%a%F{7})%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-ahead
zstyle ':vcs_info:git*' check-for-changes true

+vi-git-untracked(){
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
      git status --porcelain | fgrep '??' &> /dev/null ; then
    hook_com[staged]+='%F{red}?%f'
  fi
}

+vi-git-ahead() {
  local ahead
  local -a gitstatus

  ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | xargs)
  [ $ahead -ne 0 ] && gitstatus+="%F{red}!%f"
  hook_com[misc]+=${gitstatus}
}

precmd() {
  vcs_info
}

prompt_jobs() {
  echo -n "%F{7}%(1j.%j .)%f"
}

prompt_dir() {
  echo -n '%F{cyan}%c%f'
}

prompt_git() {
  local git_status="${vcs_info_msg_0_}"
  [[ $git_status != '' ]] && echo -n " $git_status"
}

prompt_vagrant_status() {
  local running="$(cat ~/.vagrant-global-status 2> /dev/null)"
  [ -n "$running" ] && echo -n "%F{7}[$running]%f"
}

prompt_marker() {
  echo "%F{red}%(!.#.:) %f"
}

prompt_divider() {
  echo "\x1b[38;2;39;43;59m$(repeat $COLUMNS printf "%s" "—")\x1b[0m"
}

prompt_virtualenv() {
  [[ ! -z "$VIRTUAL_ENV" ]] && echo -n "(`basename \"$VIRTUAL_ENV\"`) "
}

build_prompt() {
  prompt_divider
  prompt_virtualenv
  prompt_jobs
  prompt_dir
  prompt_git
  prompt_marker
}

PROMPT='$(build_prompt)'
RPROMPT='$(prompt_vagrant_status)'
