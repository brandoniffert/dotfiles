PROMPT_CARET='❯'
PROMPT_JOBS='⚙'
PROMPT_PUSH='●'

prompt_git() {
  st=$(git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo -n ""
  else
    if [[ $st == "nothing to commit, working directory clean" ]]
    then
      echo -n " (%F{green}%}$(git_prompt_info)%f)"
    else
      echo -n " (%F{red}%}$(git_prompt_info)%f)"
    fi
  fi
}

git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2>/dev/null) || return
  echo -n "${ref#refs/heads/}"
}

unpushed() {
  git cherry -v @{upstream} 2>/dev/null
}

prompt_need_push() {
  [[ $(unpushed) != "" ]] && echo -n " %F{red}%}$PROMPT_PUSH%f "
}

prompt_dir() {
  echo -n "%F{blue}%}%~%f"
}

prompt_user() {
  echo -n "%B%F{green}%}%n%f%b"
}

prompt_jobs() {
  [[ $(jobs -l | wc -l) -gt 0 ]] && echo -n "%B%F{red}%}$PROMPT_JOBS%f%b "
}

PROMPT=$'$(prompt_jobs)$(prompt_user):$(prompt_dir)$(prompt_git)$(prompt_need_push)\n$PROMPT_CARET '
