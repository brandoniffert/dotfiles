precmd () {
  echo -ne "\e]2;${PWD/${HOME}/~}\a" # set window title to full string
  echo -ne "\e]1;$PWD:t\a" # set tab title to rightmost 24 characters
}
