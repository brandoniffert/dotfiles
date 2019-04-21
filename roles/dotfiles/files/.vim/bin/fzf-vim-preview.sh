#!/usr/bin/env bash

# Taken from https://github.com/junegunn/fzf.vim/blob/b31512e2a2d062ee4b6eb38864594c83f1ad2c2f/bin/preview.sh
# Modified to replace the highlighted line with a custom background color instead of using a REVERSE escape sequence

HIGHLIGHT="\x1b[43m\x1b[1m\x1b[30m"
RESET="\x1b[m"

if [ -z "$1" ]; then
  echo "usage: $0 FILENAME[:LINENO][:IGNORED]"
  exit 1
fi

IFS=':' read -r -a INPUT <<< "$1"
FILE=${INPUT[0]}
CENTER=${INPUT[1]}

if [[ $1 =~ ^[A-Z]:\\ ]]; then
  FILE=$FILE:${INPUT[1]}
  CENTER=${INPUT[2]}
fi

if [ ! -r "$FILE" ]; then
  echo "File not found ${FILE}"
  exit 1
fi

if [[ "$(file --dereference --mime "$FILE")" =~ binary ]]; then
  echo "$1 is a binary file"
  exit 0
fi

if [ -z "$CENTER" ]; then
  CENTER=0
fi

if [ -z "$LINES" ]; then
  if [ -r /dev/tty ]; then
    LINES=$(stty size < /dev/tty | awk '{print $1}')
  else
    LINES=40
  fi
fi

FIRST=$((CENTER-LINES/3))
FIRST=$((FIRST < 1 ? 1 : FIRST))
LAST=$((FIRST+LINES-1))

DEFAULT_COMMAND="cat {}"
CMD=${FZF_PREVIEW_COMMAND:-$DEFAULT_COMMAND}
CMD=${CMD//{\}/$(printf %q "$FILE")}

eval "$CMD" 2> /dev/null | awk "NR >= $FIRST && NR <= $LAST { \
    if (NR == $CENTER) \
        { gsub(/\x1b[[0-9;]*m/, \"&$HIGHLIGHT\"); printf(\"$HIGHLIGHT%s\n$RESET\", \$0); } \
    else printf(\"$RESET%s\n\", \$0); \
    }"
