let s:save_cpo = &cpo
set cpo&vim

function! vcs#svn#resolve#do(args)
  let cwd = getcwd()
  exec 'cd ' . vcs#vcs('root', a:args)

  let files = type(a:args) == type([]) ? a:args : [a:args]
  let accept = input('accept? ', '')
  let result = substitute(vcs#system(join([
        \ 'svn',
        \ 'resolve',
        \ '--accept',
        \ accept,
        \ join(vcs#escape(files), ' ')
        \ ], ' ')), '\r', '', 'g')

  exec 'cd ' . cwd
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

