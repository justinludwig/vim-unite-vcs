let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#delete#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000

  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', files)
  let result = substitute(vcs#system(join([
        \ 'git',
        \ 'rm',
        \ '-f',
        \ '--cached',
        \ join(files, ' ')
        \ ])), '\r', '', 'g')
  exec 'lcd ' . cwd
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


