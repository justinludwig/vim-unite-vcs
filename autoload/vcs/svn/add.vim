let s:save_cpo  = &cpo
set cpo&vim

function! vcs#svn#add#do(...)
  let files = type(a:1) == type([]) ? a:1 : [a:1]
  return vcs#system(join([
        \ 'svn',
        \ 'add',
        \ join(files, ' ')
        \ ]))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

