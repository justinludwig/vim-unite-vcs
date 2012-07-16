let s:save_cpo  = &cpo
set cpo&vim

function! vcs#svn#cat#do(args)
  let target = vcs#target(a:args)
  let revision = len(a:args) == 2 ? a:args[1] : 'HEAD'

  return substitute(vcs#system(join([
        \ 'svn',
        \ 'cat',
        \ '--revision',
        \ revision,
        \ target
        \ ], ' ')), '\r', '', 'g')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

