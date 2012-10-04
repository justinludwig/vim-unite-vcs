let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#changeset#do(args)
  let target = vcs#target(a:args)
  let revision = len(a:args) == 2 ? a:args[1] : 'HEAD'
  let str = s:system(target, revision)
  let list = s:str2list(str)
  let changeset = s:parse(target, revision, list)
  return changeset
endfunction

function! s:system(target, revision)
  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', [a:target])
  let result = vcs#system(join([
        \ 'git',
        \ 'log',
        \ '--name-status',
        \ '--pretty=format:"' . g:vcs#git#log_format . '"',
        \ '-1',
        \ a:revision,
        \ ], ' '))
  exec 'lcd ' . cwd
  return result
endfunction

function! s:str2list(str)
  let list = split(a:str, "\n")
  let list[0] = split(list[0], '\t')
  return list
endfunction

function! s:parse(target, revision, list)
  return {
        \ 'revision': a:list[0][0],
        \ 'prev_revision': a:list[0][1],
        \ 'author': a:list[0][2],
        \ 'date': join(split(a:list[0][4], ' ')[0:1], ' '),
        \ 'message': a:list[0][5],
        \ 'changesets': map(a:list[1:], "{
          \ 'path': substitute(v:val, '^.*\\s', '', 'g'),
          \ 'status': substitute(v:val, '\\s.*$', '', 'g'),
          \ }")
        \ }
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

