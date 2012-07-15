let s:save_cpo  = &cpo
set cpo&vim

function! vcs#svn#add#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]
  return substitute(vcs#system(join([
        \ 'svn',
        \ 'add',
        \ join(files, ' ')
        \ ])), '\r', '', 'g')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

