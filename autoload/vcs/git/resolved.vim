let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#resolved#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000

  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', files)
  let result = substitute(vcs#system(join([
        \ 'git',
        \ 'add',
        \ join(files, ' ')
        \ ])), '\r', '', 'g')
  let result = substitute(vcs#system(join([
        \ 'git',
        \ 'rebase',
        \ '--continue'
        \ ])), '\r', '', 'g')
  exec 'lcd ' . cwd
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

