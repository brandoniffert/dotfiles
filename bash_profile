bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

if type rbenv &> /dev/null; then
  eval "$(rbenv init - --no-rehash)"
fi

function __git_repo_status() {
  local __ref=''
  local __st=''
  local __symbol=''
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    __st=$(git status 2>/dev/null | tail -n 1)
    __ref=$(git symbolic-ref -q HEAD || (git name-rev --name-only --no-undefined --tags --always HEAD)) 2> /dev/null

    if [[ $__st == "nothing to commit, working directory clean" ]]
    then
      echo -n '\[\e[32m\]'
    else
      __symbol='?'
      echo -n '\[\e[31m\]'
    fi

    [ $(git diff --cached) 2>/dev/null ] && __symbol='+'
    [[ $(git cherry -v @{upstream} 2>/dev/null) != "" ]] && __symbol='!'

    echo -n "(${__ref#refs\/heads\/}$__symbol)\[\e[00m\]"
  fi
}

function __custom_prompt() {
  local __time="\[\e[01;30m\]\t\[\e[00;37m\]"
  local __user_host="\u\[\e[01;37m\]:\[\e[00;33m\]\h\[\e[01;33m\]"
  local __cur_dir="\[\e[00;34m\]\w\[\e[01;34m\]"
  local __tail="\[\e[00m\]\n\$ "

  export PS1="$__time $__user_host $__cur_dir $(__git_repo_status) $__tail"
}
__custom_prompt
