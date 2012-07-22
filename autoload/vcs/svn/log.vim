let s:save_cpo  = &cpo
set cpo&vim

function! vcs#svn#log#do(args)
  let target = vcs#target(a:args)
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
  let logs = map(a:list, "{
        \ 'revision': substitute(split(v:val[0], '|')[0], '[^[:digit:]]', '', 'g'),
        \ 'author': split(v:val[0], '|')[1],
        \ 'message': v:val[2],
        \ 'path': a:target
        \ }")

  let i = 0
  while i < len(logs)
    let logs[i].prev_revision = exists('logs[i + 1].revision')  ? logs[i + 1].revision : ''
    let i = i + 1
  endwhile

  return logs
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

