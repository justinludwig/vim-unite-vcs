let s:save_cpo  = &cpo
set cpo&vim

function! vcs#svn#log#do(...)
  let target = call('vcs#target', a:000)
  let str = s:system(target)
  let list = s:str2list(str)
  let list = s:extract(list)
  let list = s:parse(target, list)
  return list
endfunction

function! s:system(target)
  return vcs#system(join([
        \ 'svn',
        \ 'log',
        \ '--limit 50',
        \ a:target
        \ ], ' '))
endfunction

function! s:str2list(str)
  return split(a:str, '------------------------------------------------------------------------')
endfunction

function! s:extract(list)
  return filter(map(a:list, "split(v:val, '\n')"), "len(v:val) > 0")
endfunction

function! s:parse(target, list)
  return map(a:list, "{
        \ 'revision': split(v:val[0], '|')[0],
        \ 'author': split(v:val[0], '|')[1],
        \ 'message': v:val[2],
        \ 'path': a:target
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

