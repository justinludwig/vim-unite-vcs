let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#revert#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000

  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', files)
  let result = substitute(vcs#system(join([
        \ 'git',
        \ 'checkout',
        \ join(files, ' ')
        \ ])), '\r', '', 'g')
  exec 'lcd ' . cwd
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


