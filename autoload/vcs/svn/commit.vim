let s:save_cpo = &cpo
set cpo&vim

function! vcs#svn#commit#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]
  " TODO: collect windows.
  exec join([
        \ '!',
        \ 'svn',
        \ '--editor-cmd',
        \ 'vim',
        \ 'commit',
        \ join(vcs#escape(files), ' ')
        \ ], ' ')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

