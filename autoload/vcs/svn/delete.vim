let s:save_cpo  = &cpo
set cpo&vim

function! vcs#svn#delete#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000
  return substitute(vcs#system(join([
        \ 'svn',
        \ 'delete',
        \ join(files, ' ')
        \ ])), '\r', '', 'g')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

