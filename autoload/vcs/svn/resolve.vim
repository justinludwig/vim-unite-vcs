let s:save_cpo = &cpo
set cpo&vim

function! vcs#svn#resolve#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]
  let accept = input('accept? ', '')
  return vcs#system([
        \ 'svn',
        \ 'resolve',
        \ '--accept',
        \ accept,
        \ join(vcs#escape(files), ' ')
        \ ])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

