# Private mode (FORGET_ME): no history writes. Sourced from .zshrc

# Delete scratch dir $1 unless a shell registered in $1.shells is still alive
_scratch_gc() {
  [[ -n $1 ]] || return
  local f
  for f in $1.shells/*(N); do
    kill -0 ${f:t} 2>/dev/null && return 1
    rm -fr $f
  done
  chmod -R u+w $1 2>/dev/null
  rm -fr $1 $1.shells
}

# Splits inherit cwd but not env, so detect a `scratch` dir by path and
# register, letting the last shell out clean up. Each shell's registration is
# a hop dir: outside the scratch tree, OSC 7 reports it instead of PWD so a
# split still lands under scratch, then follows its `cwd` file
_scratch_tmp=${${TMPDIR:-/tmp}:A}
if [[ ${PWD:A} == $_scratch_tmp/scratch.* ]]; then
  _scratch_root=${${PWD:A}#$_scratch_tmp/}
  _scratch_root=$_scratch_tmp/${${_scratch_root%%/*}%.shells}
  if [[ ${PWD:A} == $_scratch_root.shells/* ]]; then
    _scratch_cwd=
    [[ -r $PWD/cwd ]] && _scratch_cwd=$(<$PWD/cwd)
    [[ -d $_scratch_cwd ]] || _scratch_cwd=$_scratch_root
    builtin cd -q -- $_scratch_cwd
    OLDPWD=$PWD
    unset _scratch_cwd
  fi
  _scratch_hop=$_scratch_root.shells/$$
  # 077: the cwd file would otherwise be world-readable if TMPDIR is /tmp
  (umask 077; mkdir -p $_scratch_hop)
  _scratch_release() { rm -fr $_scratch_hop; _scratch_gc $_scratch_root }
  add-zsh-hook zshexit _scratch_release
  trap '_scratch_release; exit 129' HUP
  _scratch_chpwd() {
    if [[ ${PWD:A} == $_scratch_root(|/*) ]]; then
      unset _osc7_dir
    else
      [[ -d $_scratch_hop ]] || (umask 077; mkdir -p $_scratch_hop)
      print -r -- $PWD > $_scratch_hop/cwd
      _osc7_dir=$_scratch_hop
    fi
  }
  add-zsh-hook chpwd _scratch_chpwd
  _scratch_chpwd
  export FORGET_ME=1
fi
unset _scratch_tmp

if [[ -n $FORGET_ME ]]; then
  fc -R $HISTFILE
  unset HISTFILE
  # Don't record visited dirs; doctor would warn about the missing hook
  add-zsh-hook -d chpwd __zoxide_hook
  _ZO_DOCTOR=0
fi
