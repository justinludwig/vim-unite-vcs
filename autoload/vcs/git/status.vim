let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#status#do(args)
  let target = vcs#target(a:args)
  let str = s:system(target)
  let list = s:str2list(str)
  let list = s:extract(list)
  let list = s:parse(target, list)
  return list
endfunction

function! s:system(target)
  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', [a:target])
  let result = vcs#system(join([
        \ 'git',
        \ 'status',
        \ '--short',
        \ a:target
        \ ], ' '))
  exec 'lcd ' . cwd
  return result
endfunction

function! s:str2list(str)
  return split(a:str, '\n')
endfunction

function! s:extract(list)
  return a:list
endfunction

function! s:parse(target, list)
  let root = vcs#vcs('root', [a:target])
  return map(a:list, "{
        \ 'path': root . '/' . v:val[3:-1],
        \ 'status': v:val[0:2],
        \ 'line': v:val
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

