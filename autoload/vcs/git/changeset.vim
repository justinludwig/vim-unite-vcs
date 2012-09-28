let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#changeset#do(args)
  let target = vcs#target(a:args)
  let revision = len(a:args) == 2 ? a:args[1] : 'HEAD'
  let str = s:system(target, revision)
  let list = s:str2list(str)
  let list = s:extract(list)
  let list = s:parse(target, revision, list)
  return list
endfunction

function! s:system(target, revision)
  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', [a:target])
  let result = vcs#system(join([
        \ 'git',
        \ 'log',
        \ '--name-status',
        \ '-1',
        \ a:revision,
        \ ], ' '))
  exec 'lcd ' . cwd
  return result
endfunction

function! s:str2list(str)
    return split(a:str, 'commit ')
endfunction

function! s:extract(list)
  let list = map(a:list, 'reverse(split(v:val, "\n"))')[0]

  let result = []
  for val in list
    if val == ''
      break
    endif
    call add(result, val)
  endfor
  return result
endfunction

function! s:parse(target, revision, list)
  let logs = map(a:list, "{
        \ 'status': substitute(v:val, '\\s.*$', '', 'g'),
        \ 'path': substitute(v:val, '^.*\\s', '', 'g'),
        \ 'revision': a:revision
        \ }")
  return logs
endfunction

echo PP(vcs#git#changeset#do(['~/.vim/bundle/vim-unite-vcs', 'HEAD^^^']))

let &cpo = s:save_cpo
unlet s:save_cpo

