prompt_jobs() {
  echo -n "%F{8}%(1j.(%j) .)%f"
}

prompt_hostname() {
  echo -n "%F{blue}%m%f "
}

prompt_marker() {
  local symbol='❯'
  echo -n "%F{red}$symbol%f%F{yellow}$symbol%f%F{green}$symbol%f "
}

prompt_dir() {
  echo -n '%F{default}%~%f '
}

prompt_git() {
  local ref st symbol
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    st=$(git status 2>/dev/null | tail -n 1)
    ref=$(git symbolic-ref -q HEAD || (git name-rev --name-only --no-undefined --tags --always HEAD)) 2> /dev/null

    if [[ $st == "nothing to commit, working directory clean" ]]
    then
      echo -n '%F{green}'
    else
      symbol='?'
      echo -n '%F{red}'
    fi

    [[ $(git diff --cached) 2>/dev/null ]] && symbol='+'
    [[ $(git cherry -v @{upstream} 2>/dev/null) != "" ]] && symbol='!'

    echo -n "(${ref#(refs/heads/)}$symbol)%f "
  fi
}

prompt_vagrant_status() {
  local running="$(cat ~/.vagrant-global-status 2> /dev/null)"
  [ -n "$running" ] && echo -n "%F{8}[$running]%f"
}

prompt_status() {
  echo "\n%(?.%F{default}.%F{red})%(!.#.>)%f "
}

build_prompt() {
  prompt_jobs
  prompt_hostname
  prompt_marker
  prompt_dir
  prompt_git
  prompt_vagrant_status
  prompt_status
}

PROMPT='$(build_prompt)'
