let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#changeset#do(args)
  let cwd = getcwd()
  exec 'cd '. vcs#vcs('root', [a:args])

  let target = vcs#target(a:args)
  let revision = len(a:args) == 2 ? a:args[1] : 'HEAD'
  let str = s:system(target, revision)
  let list = s:str2list(str)
  let result = s:parse(target, revision, list)

  exec 'cd ' . cwd
  return result
endfunction

function! s:system(target, revision)
  return vcs#system(join([
        \ 'git',
        \ 'log',
        \ '--name-status',
        \ '--pretty=format:"' . g:vcs#git#log_format . '"',
        \ '-1',
        \ a:revision,
        \ ], ' '))
endfunction

function! s:str2list(str)
  let list = split(a:str, "\n")
  let list[0] = split(list[0], '\t')
  return list
endfunction

function! s:parse(target, revision, list)
  let root = vcs#vcs('root', [a:target])
  return {
        \ 'revision': a:list[0][0],
        \ 'prev_revision': a:list[0][1],
        \ 'author': a:list[0][2],
        \ 'date': join(split(a:list[0][4], ' ')[0:1], ' '),
        \ 'message': a:list[0][5],
        \ 'changesets': map(a:list[1:], "{
          \ 'path': root . '/' . substitute(v:val, '^.*\\s', '', 'g'),
          \ 'status': substitute(v:val, '\\s.*$', '', 'g'),
          \ }")
        \ }
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

