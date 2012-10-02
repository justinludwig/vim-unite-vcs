let s:save_cpo = &cpo
set cpo&vim

" HASH, PREV_HASH, AUTHOR_NAME, AUTHOR_EMAIL, AUTHOR_DATE, SUBJECT
let s:format = '%H%x09%P%x09%an%x09%ae%x09%ai%x09%s'

function! vcs#git#log#do(args)
  let target = vcs#target(a:args)
  let str = s:system(target)
  let list = s:str2list(str)
  let list = s:parse(target, list)
  return list
endfunction

function! s:system(target)
  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', [a:target])
  let result = vcs#system(join([
        \ 'git',
        \ 'log',
        \ '--pretty=format:"' . s:format . '"',
        \ vcs#escape(a:target)
        \ ], ' '))
  exec 'lcd ' . cwd
  return result
endfunction

function! s:str2list(str)
  return map(split(a:str, "\n"), "split(v:val, '\\t')")
endfunction

function! s:parse(target, list)
  return map(a:list, '{
        \ "revision": v:val[0],
        \ "prev_revision": v:val[1],
        \ "author": v:val[2],
        \ "date": v:val[4],
        \ "message": v:val[5],
        \ "path": a:target
        \ }')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

