let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#delete#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]
  return vcs#system([
        \ 'git',
        \ 'rm',
        \ '-f',
        \ '--cached',
        \ join(vcs#escape(files), ' ')
        \ ])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

