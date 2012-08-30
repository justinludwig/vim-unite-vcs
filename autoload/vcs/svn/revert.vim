let s:save_cpo = &cpo
set cpo&vim

function! vcs#svn#revert#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]
  return substitute(vcs#system(join([
        \ 'svn',
        \ 'revert',
        \ join(vcs#escape(files), ' ')
        \ ], ' ')), '\r', '', 'g')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

