# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# don't autocomplete hosts
zstyle ':completion:*:ssh:*' hosts off

# make aliased completions work
compdef t=tmux
compdef g=git
