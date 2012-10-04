let s:save_cpo = &cpo
set cpo&vim

let g:vcs#svn#log_separator = '------------------------------------------------------------------------'

let &cpo = s:save_cpo
unlet s:save_cpo


