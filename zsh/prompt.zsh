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
        echo " %{$fg[red]%}!!!%{$reset_color%} "
    fi
}

directory_name() {
    echo "%{$fg[blue]%}${PWD/#$HOME/~}%{$reset_color%}"
}

current_user() {
  if [[ $EUID -ne 0 ]]; then
    echo "%{$fg_bold[green]%}%n%{$reset_color%}"
  else
    echo "%{$fg[red]%}root%{$reset_color%}"
  fi
}

precmd() {
    title "zsh" "%n@%m" "%55<...<%~"
}

suspended_jobs() {
  suspended=$(jobs)
  if [[ $suspended == "" ]]
  then
  else
    echo "%{$fg_bold[red]%}⚙%{$reset_color%} "
  fi
}

# Ensures that $terminfo values are valid and updates editor information when
# the keymap changes.
function zle-keymap-select zle-line-init zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( ${+terminfo[smkx]} )); then
    printf '%s' ${terminfo[smkx]}
  fi
  if (( ${+terminfo[rmkx]} )); then
    printf '%s' ${terminfo[rmkx]}
  fi

  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

function vi_mode_prompt_info() {
  COMMAND_MODE="%{$fg_bold[red]%}➟%{$reset_color%}"
  INSERT_MODE="➟"
  echo "${${KEYMAP/vicmd/$COMMAND_MODE}/(main|viins)/$INSERT_MODE}"
}

export PROMPT=$'$(suspended_jobs)$(current_user) in $(directory_name)$(git_dirty)$(need_push)\n$(vi_mode_prompt_info) '
