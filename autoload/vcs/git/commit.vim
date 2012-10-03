let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#commit#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]

  " TODO: collect windows.
  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', files)
  exec join([
        \ '!',
        \ 'export EDITOR=vim;',
        \ 'git',
        \ 'commit',
        \ '--include',
        \ join(vcs#escape(files), ' ')
        \ ], ' ')
  exec 'lcd ' . cwd
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

