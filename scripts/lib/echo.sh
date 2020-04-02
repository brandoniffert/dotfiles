#!/bin/bash
# shellcheck disable=SC2034

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  echo "[error] script \"$0\" is intended to be sourced, not executed directly"
  exit 1
fi

# https://gist.github.com/tavinus/925c7c9e67b5ba20ae38637fd0e06b07
ESeq="\x1b["
RCol="$ESeq"'0m' # Text Reset

# Regular            Bold
Bla="$ESeq"'0;30m';  BBla="$ESeq"'1;30m';
Red="$ESeq"'0;31m';  BRed="$ESeq"'1;31m';
Gre="$ESeq"'0;32m';  BGre="$ESeq"'1;32m';
Yel="$ESeq"'0;33m';  BYel="$ESeq"'1;33m';
Blu="$ESeq"'0;34m';  BBlu="$ESeq"'1;34m';
Pur="$ESeq"'0;35m';  BPur="$ESeq"'1;35m';
Cya="$ESeq"'0;36m';  BCya="$ESeq"'1;36m';
Whi="$ESeq"'0;37m';  BWhi="$ESeq"'1;37m';

TASK_MARKER=▸
STEP_MARKER=•

header() {
  printf "%$(tput cols)s" | tr ' ' '─'
  echo -e "$1"
  printf "%$(tput cols)s" | tr ' ' '─'
  echo
}

group_header() {
  header "${BWhi}GROUP:${RCol} $1"
}

task_start() {
  local name="$TASK_MARKER TASK [$1] "
  local name_length=${#name}
  local col_length
  local fill_length
  col_length=$(tput cols)
  fill_length=$(( col_length - name_length ))

  echo -en "${BWhi}$name${RCol}"
  printf "%${fill_length}s" | tr ' ' '·'
  echo
}

task_end() {
  echo
}

task_success() {
  echo -e "${Gre}$STEP_MARKER ${1-success}${RCol}"
}

task_error() {
  echo -e "${Red}$STEP_MARKER $1${RCol}"
}

task_error_exit() {
  task_error "$@"
  exit 1
}

task_info() {
  echo -e "${Blu}$STEP_MARKER $1${RCol}"
}

task_skip() {
  echo -e "${Yel}$STEP_MARKER ${1-skipping}${RCol}"
}
