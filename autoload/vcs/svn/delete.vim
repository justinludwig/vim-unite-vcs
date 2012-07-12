function! vcs#svn#delete#do(...)
  let files = type(a:1) == type([]) ? a:1 : [a:1]
  return vcs#system(join([
        \ 'svn',
        \ 'delete',
        \ join(files, ' ')
        \ ]))
endfunction
