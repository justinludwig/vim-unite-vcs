let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#log#do(...)
  let target = call('vcs#target', a:000)
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
        \ 'log',
        \ a:target
        \ ], ' '))
  exec 'lcd ' . cwd
  return result
endfunction

function! s:str2list(str)
    return split(a:str, 'commit ')
endfunction

function! s:extract(list)
  return filter(map(a:list, 'split(v:val, "\n")'), 'len(v:val) > 2')
endfunction

function! s:parse(target, list)
  return map(a:list, '{
        \ "revision": v:val[0],
        \ "author": split(v:val[1], "Author: ")[0],
        \ "message": v:val[4][4:-1],
        \ "path": a:target
        \ }')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

