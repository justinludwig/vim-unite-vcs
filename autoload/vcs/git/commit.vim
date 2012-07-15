let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#commit#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]

  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', files)
  exec join([
        \ '!',
        \ 'git',
        \ 'commit',
        \ join(files, ' ')
        \ ], ' ')
  exec 'lcd ' . cwd
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

