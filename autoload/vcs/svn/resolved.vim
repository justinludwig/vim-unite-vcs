let s:save_cpo = &cpo
set cpo&vim

function! vcs#svn#resolved#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]
  return vcs#system([
        \ 'svn',
        \ 'resolved',
        \ join(vcs#escape(files), ' ')
        \ ])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

