function! vcs#svn#revert#do(...)
  let files = type(a:1) == type([]) ? a:1 : [a:1]
  return vcs#system(join([
        \ 'svn',
        \ 'revert',
        \ join(files, ' ')
        \ ]))
endfunction

