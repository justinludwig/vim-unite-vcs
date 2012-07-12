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
