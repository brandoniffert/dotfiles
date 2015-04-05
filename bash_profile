if [ -f /etc/bash_completion.d/git ]; then
  source /etc/bash_completion.d/git
  export PS1='\[\e[01;30m\]\t\[\e[00;37m\] \u\[\e[01;37m\]:\[\e[00;33m\]\h\[\e[01;33m\] in \[\e[00;34m\]\w\[\e[01;34m\] `[[ $(git status 2> /dev/null | head -n2 | tail -n1) != "# Changes to be committed:" ]] && echo "\[\e[31m\]" || echo "\[\e[33m\]"``[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] || echo "\[\e[32m\]"`$(__git_ps1 "(%s)\[\e[00m\]")\[\e[00m\]\n\$ '
fi

if type rbenv &> /dev/null; then
  eval "$(rbenv init - --no-rehash)"
fi
