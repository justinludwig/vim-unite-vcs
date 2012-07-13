function! vcs#svn#resolve#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000
  let accept = input('accept? ', '')
  return substitute(vcs#system(join([
        \ 'svn',
        \ 'resolve',
        \ '--accept',
        \ accept,
        \ join(files, ' ')
        \ ], ' ')), '\r', '', 'g')
endfunction


 
