autoload -Uz vcs_info

# Setup git
zstyle ':vcs_info:*' enable git

# Git info styles
zstyle ':vcs_info:git*' unstagedstr '%F{red}?%f'
zstyle ':vcs_info:git*' stagedstr '%F{red}+%f'
zstyle ':vcs_info:git*' formats '%F{8}[%b%f%u%c%F{8}]%f'
zstyle ':vcs_info:git*' actionformats '%F{8}[%b%f%u%c:%F{green}%a%F{8}]%f'
zstyle ':vcs_info:git*' check-for-changes true

precmd() {
  vcs_info
}

prompt_jobs() {
  echo -n "%F{8}%(1j.[%j] .)%f"
}

prompt_last_status() {
  if [ $? != 0 ]; then
    echo -n "%{$bg[red]%} %{$bg[default]%} "
  else
    echo -n "%{$bg[green]%} %{$bg[default]%} "
  fi
}

prompt_hostname() {
  echo -n "%F{8}%m%f"
}

prompt_dir() {
  echo -n '%F{default}:%c%f '
}

prompt_git() {
  local git_status="${vcs_info_msg_0_}"
  if [[ $git_status != '' ]]; then
    echo -n "$git_status "
  fi
}

prompt_vagrant_status() {
  local running="$(cat ~/.vagrant-global-status 2> /dev/null)"
  [ -n "$running" ] && echo -n "%F{8}[$running]%f"
}

prompt_marker() {
  echo "%(!.#.$) "
}

build_prompt() {
  prompt_last_status
  prompt_jobs
  prompt_hostname
  prompt_dir
  prompt_git
  prompt_marker
}

PROMPT='$(build_prompt)'
RPROMPT='$(prompt_vagrant_status)'
