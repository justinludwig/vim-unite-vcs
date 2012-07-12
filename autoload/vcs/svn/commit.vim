let s:save_cpo  = &cpo
set cpo&vim

function! vcs#svn#commit#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000
  exec join([
        \ '!',
        \ 'svn',
        \ '--editor-cmd',
        \ 'vim',
        \ 'commit',
        \ join(files, ' ')
        \ ], ' ')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

