let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#cat#do(args)
  let target = vcs#target(a:args)
  let revision = len(a:args) == 2 ? a:args[1] : 'HEAD'
  let root = vcs#vcs('root', [target])
  return substitute(vcs#system([
        \ 'git',
        \ 'cat-file',
        \ '-p',
        \ revision . ":" . vcs#escape(target[strlen(root) + 1:-1])
        \ ]), '\n$', '', 'g')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

