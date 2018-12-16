autoload -Uz vcs_info
autoload -U add-zsh-hook
autoload -U colors && colors

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f"
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f"
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked git-aheadbehind git-stash
zstyle ':vcs_info:git*:*' formats '%b%m%c%u '
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

if [[ -n "$TMUX" ]]; then
  local LVL=$(($SHLVL - 1))
else
  local LVL=$SHLVL
fi

if [[ -n "$VIRTUAL_ENV" ]]; then
  local VENV="%F{black}(${VIRTUAL_ENV##*/})%f"
else
  local VENV=''
fi

local SSHTTY="%F{green}${SSH_TTY:+%n@%m}%f%B${SSH_TTY:+:}%b"
local DIR="%F{blue}%1~%f "
local JOBS_RETURNVAL="%F{red}%B%(1j.*.)%(?..!)%b%f"

if [[ $EUID -eq 0 ]]; then
  local SUFFIX="%F{red}$(printf '#%.0s' {1..$LVL})%f"
else
  local SUFFIX="%F{white}$(printf '\$%.0s' {1..$LVL})%f"
fi

export PS1="${SSHTTY}${DIR}${JOBS_RETURNVAL}${SUFFIX} "
export RPROMPT_BASE="\${vcs_info_msg_0_%%}${VENV}"
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{red}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# Show the time it took to execute a command
typeset -F SECONDS
function record-start-time() {
  emulate -L zsh
  ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}

function report-start-time() {
  emulate -L zsh

  if [ $ZSH_START_TIME ]; then
    local DELTA=$(($SECONDS - $ZSH_START_TIME))
    local DAYS=$((~~($DELTA / 86400)))
    local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
    local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
    local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
    local ELAPSED=''
    test "$DAYS" != '0' && ELAPSED="${DAYS}d"
    test "$HOURS" != '0' && ELAPSED="${ELAPSED}${HOURS}h"
    test "$MINUTES" != '0' && ELAPSED="${ELAPSED}${MINUTES}m"
    if [ "$ELAPSED" = '' ]; then
      SECS="$(print -f "%.2f" $SECS)s"
    elif [ "$DAYS" != '0' ]; then
      SECS=''
    else
      SECS="$((~~$SECS))s"
    fi
    ELAPSED="${ELAPSED}${SECS}"
    local ITALIC_ON=$'\e[3m'
    local ITALIC_OFF=$'\e[23m'
    export RPROMPT="%F{8}%{$ITALIC_ON%}${ELAPSED}%{$ITALIC_OFF%}%f $RPROMPT_BASE"
    unset ZSH_START_TIME
  else
    export RPROMPT="$RPROMPT_BASE"
  fi
}

add-zsh-hook preexec record-start-time
add-zsh-hook precmd report-start-time
add-zsh-hook precmd vcs_info
