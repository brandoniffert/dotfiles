autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

git_branch() {
    echo $(/usr/bin/git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
    st=$(/usr/bin/git status 2>/dev/null | tail -n 1)
    if [[ $st == "" ]]
    then
        echo ""
    else
        if [[ $st == "nothing to commit (working directory clean)" ]]
        then
            echo " on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
        else
            echo " on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
        fi
    fi
}

git_prompt_info () {
    ref=$(/usr/bin/git symbolic-ref HEAD 2>/dev/null) || return
    echo "${ref#refs/heads/}"
}

unpushed () {
    /usr/bin/git cherry -v @{upstream} 2>/dev/null
}

need_push () {
    if [[ $(unpushed) == "" ]]
    then
        echo " "
    else
        echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
    fi
}

directory_name() {
    echo "%{$fg_bold[blue]%}${PWD/#$HOME/~}%{$reset_color%}"
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

export PROMPT=$'$(current_user) in $(directory_name)$(git_dirty)$(need_push)%{$fg_bold[blue]%}\n$%{$reset_color%} '
