let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#commit#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]
  " TODO: collect windows.
  call vcs#execute([
        \ '!',
        \ 'export EDITOR=vim;',
        \ 'git',
        \ 'commit',
        \ '--include',
        \ join(vcs#escape(files), ' ')
        \ ])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

