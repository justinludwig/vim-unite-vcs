let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#add#do(...)
  let files = a:0 == 1 ? (type(a:1) == type([]) ? a:1 : [a:1]) : a:000

  let cwd = getcwd()
  exec 'cd ' . vcs#vcs('root', [a:target])
  let result = substitute(vcs#system(join([
        \ 'git',
        \ 'add',
        \ join(files, ' ')
        \ ])), '\r', '', 'g')
  exec 'cd ' . cwd
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

