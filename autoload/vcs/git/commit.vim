let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#commit#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000
  let cwd = getcwd()
  exec 'cd ' . vcs#vcs('root', files)
  exec join([
        \ '!',
        \ 'git',
        \ 'commit',
        \ join(files, ' ')
        \ ], ' ')
  exec 'cd ' . cwd
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

