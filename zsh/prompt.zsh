autoload colors && colors

git=`which git`

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ $st == "nothing to commit, working directory clean" ]]
    then
      echo " (%{$fg[green]%}$(git_prompt_info)%{$reset_color%})"
    else
      echo " (%{$fg[red]%}$(git_prompt_info)%{$reset_color%})"
    fi
  fi
}

git_prompt_info () {
  ref=$($git symbolic-ref HEAD 2>/dev/null) || return
  echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " %{$fg[red]%}●%{$reset_color%} "
  fi
}

directory_name() {
  echo "%{$fg[blue]%}%~%F%{$reset_color%}"
}

current_user() {
  if [[ $EUID -ne 0 ]]; then
    echo "%{$fg_bold[green]%}%n%{$reset_color%}"
  else
    echo "%{$fg[red]%}root%{$reset_color%}"
  fi
}

suspended_jobs() {
  suspended=$(jobs)
  if [[ $suspended != "" ]]; then
    echo "%{$fg_bold[red]%}⚙%{$reset_color%} "
  fi
}

vim_ins_mode="❯"
vim_cmd_mode="%{$fg_bold[red]%}${vim_ins_mode}%{$reset_color%}"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

export PROMPT=$'$(suspended_jobs)$(current_user) in $(directory_name)$(git_dirty)$(need_push)\n${vim_mode} '
