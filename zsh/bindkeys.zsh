# use emacs key bindings
bindkey -e

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

bindkey ' ' magic-space    # also do history expansion on space

bindkey "^K" kill-whole-line # ctrl-k
bindkey "^R" history-incremental-search-backward # ctrl-r
bindkey "^A" beginning-of-line # ctrl-a
bindkey "^E" end-of-line # ctrl-e
bindkey "^D" delete-char # ctrl-d
bindkey "^F" forward-char # ctrl-f
bindkey "^B" backward-char # ctrl-b

# allow C-x C-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
