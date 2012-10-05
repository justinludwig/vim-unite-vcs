let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#cat#do(args)
  let cwd = getcwd()
  exec 'cd '. vcs#vcs('root', [a:args])

  let target = vcs#target(a:args)
  let revision = len(a:args) == 2 ? a:args[1] : 'HEAD'
  let root = vcs#vcs('root', [target])
  let result = substitute(vcs#system(join([
        \ 'git',
        \ 'show',
        \ revision . ":" . vcs#escape(target[strlen(root) + 1:-1])
        \ ], ' ')), '\r', '', 'g')

  exec 'cd ' . cwd
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

