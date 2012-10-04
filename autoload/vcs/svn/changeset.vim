let s:save_cpo = &cpo
set cpo&vim

function! vcs#svn#changeset#do(args)
  let target = vcs#target(a:args)
  let revision = len(a:args) == 2 ? a:args[1] : 'HEAD'
  let str = s:system(target, revision)
  let list = s:str2list(str)
  let list = s:extract(list)
  return s:parse(target, list, revision)
endfunction

function! s:system(target, revision)
  return vcs#system(join([
        \ 'svn',
        \ 'log',
        \ '--limit 2',
        \ '--verbose',
        \ '--stop-on-copy',
        \ vcs#escape(a:target) . '@' . a:revision
        \ ], ' '))
endfunction

function! s:str2list(str)
  return split(a:str, g:vcs#svn#log_separator)
endfunction

function! s:extract(list)
  let list = filter(map(a:list, "split(v:val, '\n')"), "len(v:val)")
  let list = filter(list, "len(v:val) > 2")
  let list = map(list, "[v:val[0]] + v:val[2:-1]")
  let list = map(list, "[split(v:val[0], '|')] + v:val[1:-1]")
  let list = filter(list, "exists('v:val[0][0]') && exists('v:val[0][1]') && exists('v:val[0][2]')")
  return list
endfunction

function! s:parse(target, list, revision)
  let changesets = []
  let message = ''
  let i = 1
  for item in a:list[0][1:-1]
    if item == ''
      let message = a:list[0][i + 1]
      break
    endif
    let item = substitute(item, '^\s*\|\s*$', '', 'g')
    call add(changesets, {
          \ 'path': s:repository2working(a:target, substitute(item, '^.*\s', '', 'g')),
          \ 'status': substitute(item, '\s.*$', '', 'g'),
          \ })
    let i = i + 1
  endfor
  return {
        \ 'revision': substitute(a:list[0][0][0], '^\s*r\=\|\s*$', '', 'g'),
        \ 'prev_revision': exists('a:list[1]') ? substitute(a:list[1][0][0], '^\s*r\=\|\s*$', '', 'g') : '',
        \ 'author': substitute(a:list[0][0][1], '^\s*\|\s*$', '', 'g'),
        \ 'date': join(split(substitute(a:list[0][0][2], '^\s*\|\s*$', '', 'g'), ' ')[0:1], ' '),
        \ 'message': message,
        \ 'changesets': changesets
        \ }
endfunction

function! s:repository2working(target, path)
  let list = map(split(vcs#system(join([
        \ 'svn',
        \ 'info',
        \ a:target
        \ ], ' ')), "\n")[2:3], "join(split(v:val, ' ')[1:-1], '')")
  return a:path[len(list[0]) - len(list[1]) + 1:-1]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

