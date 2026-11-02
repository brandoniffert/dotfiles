# Private mode (FORGET_ME): no history writes. Sourced from .zshrc

# Delete scratch dir $1 unless a shell registered in $1.shells is still alive
_scratch_gc() {
  [[ -n $1 ]] || return
  local f
  for f in $1.shells/*(N); do
    kill -0 ${f:t} 2>/dev/null && return 1
    rm -f $f
  done
  chmod -R u+w $1 2>/dev/null
  rm -fr $1 $1.shells
}

# Splits inherit cwd but not env, so detect a `scratch` dir by path and
# register, letting the last shell out clean up
_scratch_tmp=${${TMPDIR:-/tmp}:A}
if [[ ${PWD:A} == $_scratch_tmp/scratch.* ]]; then
  _scratch_root=${${PWD:A}#$_scratch_tmp/}
  _scratch_root=$_scratch_tmp/${_scratch_root%%/*}
  mkdir -p $_scratch_root.shells && : > $_scratch_root.shells/$$
  _scratch_release() { rm -f $_scratch_root.shells/$$; _scratch_gc $_scratch_root }
  add-zsh-hook zshexit _scratch_release
  trap '_scratch_release; exit 129' HUP
  export FORGET_ME=1
fi
unset _scratch_tmp

if [[ -n $FORGET_ME ]]; then
  fc -R $HISTFILE
  unset HISTFILE
fi
