let s:save_cpo = &cpo
set cpo&vim

let g:vcs#svn#log_separator = '------------------------------------------------------------------------'
let g:vcs#svn#commit_msgfile= 'svn-commit.tmp'
let g:vcs#svn#commit_ignore = '--This line, and those below, will be ignored--'

let &cpo = s:save_cpo
unlet s:save_cpo


