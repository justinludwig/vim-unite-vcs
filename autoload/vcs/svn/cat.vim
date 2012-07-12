let s:save_cpo  = &cpo
set cpo&vim


function! vcs#svn#cat#do(...)
  let target = call('vcs#target', a:000)
  let revision = a:0 == 2 ? substitute(a:2, '[^[:digit:]]', '', 'g') : 'HEAD'
  return substitute(vcs#system(join([
        \ 'svn',
        \ 'cat',
        \ target,
        \ '--revision',
        \ revision
        \ ], ' ')), '\r', '', 'g')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
