let s:save_cpo  = &cpo
set cpo&vim



function! vcs#git#status#do(...)
  let target = call('vcs#target', a:000)
  let str = s:system(target)
  let list = s:str2list(str)
  let list = s:extract(list)
  let list = s:parse(list)
  return list
endfunction

function! s:system(target)
  let root = vcs#vcs('root', [a:target])
  let relative = a:target[strlen(root)+1:-1] 

  return vcs#system(join([
        \ 'git',
        \ '--git-dir=' . root . '/.git',
        \ 'status',
        \ '--short',
        \ relative
        \ ], ' '))
endfunction

function! s:str2list(str)
  return split(a:str, '\n')
endfunction

function! s:extract(list)
  return a:list
endfunction

function! s:parse(list)
  return map( a:list , '{
    \ "path"  :split( v:val , " " )[1] ,
    \ "status":split( v:val , " " )[0] ,
    \ "line"  :v:val
    \ }' )
endfunction





let &cpo = s:save_cpo
unlet s:save_cpo
