autoload -Uz vcs_info
autoload -U add-zsh-hook
autoload -U colors && colors

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f"
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f"
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked git-aheadbehind git-stash
zstyle ':vcs_info:git*:*' formats '%F{black}[%f%b%m%c%u%F{black}]%f '
zstyle ':vcs_info:git*:*' actionformats '%b|%a%m%c%u '

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{yellow}●%f"
  fi
}

function +vi-git-aheadbehind() {
  emulate -L zsh
  local ahead behind branch_name
  local -a gitstatus

  branch_name=$(command git symbolic-ref --short HEAD 2> /dev/null)

  ahead=$(command git rev-list "${branch_name}"@{upstream}..HEAD 2> /dev/null | wc -l)
  (( ahead )) && gitstatus+=( "%F{green}+${ahead// /}%f" )

  behind=$(command git rev-list HEAD.."${branch_name}"@{upstream} 2> /dev/null | wc -l)
  (( behind )) && gitstatus+=( "%F{yellow}-${behind// /}%f" )

  hook_com[misc]+=${(j::)gitstatus}
}

function +vi-git-stash() {
  local stashes
  local -a gitstatus

  stashes=$(git stash list 2>/dev/null | wc -l)
  (( stashes )) && gitstatus="%F{red}*%f"

  hook_com[misc]+=${(j::)gitstatus}
}

function venv_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "%F{black}(%fvenv%F{black})%f"
  fi
}

function () {
  local TMUXING=$([[ "$TERM" =~ "tmux" ]] && echo tmux)
  if [ -n "$TMUXING" -a -n "$TMUX" ]; then
    local LVL=$(($SHLVL - 1))
  else
    local LVL=$SHLVL
  fi

  local MARKER="%(?.%F{green}.%F{red})▍%f "
  local SSHTTY="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b"
  local DIR="%F{blue}%1~%f "
  local JOBS="%F{yellow}%(1j.* .)%f"

  if [[ $EUID -eq 0 ]]; then
    local SUFFIX="%F{red}$(printf '#%.0s' {1..$LVL})%f"
  else
    local SUFFIX="%F{white}$(printf '❯%.0s' {1..$LVL})%f"
  fi

  export PS1="${MARKER}${SSHTTY}\$(venv_info)${DIR}\${vcs_info_msg_0_%%}${JOBS}${SUFFIX} "
}

export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

add-zsh-hook precmd vcs_info
