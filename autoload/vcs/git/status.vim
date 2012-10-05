let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#status#do(args)
  let cwd = getcwd()
  exec 'cd ' . vcs#vcs('root', a:args)

  let target = vcs#target(a:args)
  let str = s:system(target)
  let list = s:str2list(str)
  let list = s:extract(list)
  let result = s:parse(target, list)

  exec 'cd ' . cwd
  return result
endfunction

function! s:system(target)
  return vcs#system(join([
        \ 'git',
        \ 'status',
        \ '--short',
        \ vcs#escape(a:target)
        \ ], ' '))
endfunction

function! s:str2list(str)
  return split(a:str, '\n')
endfunction

function! s:extract(list)
  return a:list
endfunction

function! s:parse(target, list)
  let root = vcs#vcs('root', [a:target])
  return map(a:list, "s:format(root, {
        \ 'path': v:val[3:-1],
        \ 'status': v:val[0:2],
        \ 'line': v:val
        \ })")
endfunction

function! s:format(root, status)
  if a:status.status =~# 'R'
    let a:status.path = substitute(split(a:status.path, '->')[1], '^\s*\|\s*$', '', 'g')
  endif
  let a:status.path = a:root . '/' . a:status.path
  return a:status
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

