function! vcs#svn#cat#do(...)
  let file = call('vcs#get_file', a:000)
  let revision = a:0 == 2 ? substitute(a:2, '[^[:digit:]]', '', 'g') : 'HEAD'
  return substitute(vcs#system(join([
        \ 'svn',
        \ 'cat',
        \ file,
        \ '--revision',
        \ revision
        \ ], ' ')), '\r', '', 'g')
endfunction

