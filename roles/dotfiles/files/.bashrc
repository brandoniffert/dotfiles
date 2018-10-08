# Colors
Reset='\e[0m'              # Color Reset
Black='\e[0;30m'           # Black
Red='\e[0;31m'             # Red
Green='\e[0;32m'           # Green
Yellow='\e[0;33m'          # Yellow
Blue='\e[0;34m'            # Blue
Purple='\e[0;35m'          # Purple
Cyan='\e[0;36m'            # Cyan
White='\e[0;37m'           # White
BoldBlack='\e[1;30m'       # BoldBlack
BoldRed='\e[1;31m'         # BoldRed
BoldGreen='\e[1;32m'       # BoldGreen
BoldYellow='\e[1;33m'      # BoldYellow
BoldBlue='\e[1;34m'        # BoldBlue
BoldPurple='\e[1;35m'      # BoldPurple
BoldCyan='\e[1;36m'        # BoldCyan
BoldWhite='\e[1;37m'       # BoldWhite

function __git_repo_status() {
  local __ref=''
  local __st=''
  local __symbol=''
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    __st=$(git status 2>/dev/null | tail -n 1)
    __ref=$(git symbolic-ref -q HEAD || (git name-rev --name-only --no-undefined --tags --always HEAD)) 2> /dev/null

    if [[ $__st == "nothing to commit, working directory clean" ]]
    then
      echo -en "${Green}"
    else
      __symbol='?'
      echo -en "${Red}"
    fi

    [ $(git diff --cached) 2>/dev/null ] && __symbol='+'
    [[ $(git cherry -v @{upstream} 2>/dev/null) != "" ]] && __symbol='!'

    echo -en "(${__ref#refs\/heads\/}$__symbol)${Reset}"
  fi
}

function __custom_prompt() {
  local __time="${BoldBlack}\\t${Reset}"
  local __user_host="${Reset}\\u:${Yellow}\\h${Reset}"
  local __cur_dir="${Blue}\\W${Reset}"
  local __tail="\\n\$ "

  echo "$__time $__user_host:$__cur_dir \$(__git_repo_status) $__tail"
}
PS1=$(__custom_prompt)
export PS1

export PATH="$HOME/.cargo/bin:$PATH"

# Setup rbenv
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - --no-rehash)"
fi

# fzf
FZF_BASH="${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
test -f "$FZF_BASH" && source "$FZF_BASH"
unset FZF_BASH
