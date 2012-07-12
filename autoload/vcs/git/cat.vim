let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#cat#do(...)
  let target = call('vcs#target', a:000)
  let revision = a:0 == 2 ? a:2 : 'HEAD'
  let root = vcs#vcs('root', [target])

  let cwd = getcwd()
  exec 'lcd '. root

  let result = substitute(vcs#system(join([
        \ 'git',
        \ 'show',
        \ revision . ":" . target[strlen(root) + 1:-1]
        \ ], ' ')), '\r', '', 'g')
  exec 'lcd ' . cwd
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

