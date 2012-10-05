let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#add#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]
  return vcs#system([
        \ 'git',
        \ 'add',
        \ join(vcs#escape(files), ' ')
        \ ])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

