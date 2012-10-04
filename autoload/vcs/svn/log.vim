let s:save_cpo = &cpo
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
        \ '--stop-on-copy',
        \ vcs#escape(a:target)
        \ ], ' '))
endfunction

function! s:str2list(str)
  return split(a:str, g:vcs#svn#log_separator)
endfunction

function! s:extract(list)
  let list = filter(map(a:list, "filter(split(v:val, '\n'), 'strlen(v:val)')"), "len(v:val)")
  let list = map(list, "[split(v:val[0], '|'), v:val[1]]")
  let list = map(list, "[map(v:val[0], \"substitute(v:val, '^\\\\s*\\\\|\\\\s*$', '', 'g')\"), v:val[1]]")
  let list = filter(list, "exists('v:val[0][0]') && exists('v:val[0][1]') && exists('v:val[0][2]')")
  let list = map(list, "exists('v:val[1]') ? [v:val[0], v:val[1]] : [v:val[0], '']")
  return list
endfunction

function! s:parse(target, list)
  let logs = map(a:list, "{
        \ 'revision': join(split(v:val[0][0], 'r')),
        \ 'author': v:val[0][1],
        \ 'date': join(split(v:val[0][2], ' ')[0:1], ' '),
        \ 'message': v:val[1],
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

