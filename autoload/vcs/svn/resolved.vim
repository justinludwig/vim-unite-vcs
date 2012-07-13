function! vcs#svn#resolved#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000
  return substitute(vcs#system(join([
        \ 'svn',
        \ 'resolved',
        \ join(files, ' ')
        \ ], ' ')), '\r', '', 'g')
endfunction
