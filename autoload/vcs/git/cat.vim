let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#cat#do(...)
  let target = call('vcs#target', a:000)

  let root = vcs#vcs('root', [target])

  let relative = target[strlen(root)+1:-1] 

  let revision = a:0 == 2 ? a:2 : 'HEAD'

  let joined = join([
        \ 'git',
        \ 'show',
        \ revision.":".relative 
        \ ], ' ')
  let content = substitute(vcs#system( joined ), '\r', '', 'g')
  return content
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
