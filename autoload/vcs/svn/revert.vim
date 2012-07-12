let s:save_cpo  = &cpo
set cpo&vim

function! vcs#svn#revert#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000
  return substitute(vcs#system(join([
        \ 'svn',
        \ 'revert',
        \ join(files, ' ')
        \ ], ' ')), '\r', '', 'g')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

