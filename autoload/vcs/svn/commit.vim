function! vcs#svn#commit#do(...)
  let files = type(a:1) == type([]) ? a:1 : [a:1]
  exec join([
        \ '!',
        \ 'svn',
        \ '--editor-cmd',
        \ 'vim',
        \ 'commit',
        \ join(files, ' ')
        \ ], ' ')
endfunction

