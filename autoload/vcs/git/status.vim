function! vcs#git#status#do(...)
  let target = call('vcs#target', a:000)
  let str = s:system(target)
  let list = s:str2list(str)
  let list = s:extract(list)
  let list = s:parse(list)
  return list
endfunction

function! s:system(target)
  let relative = substitute(a:target, vcs#vcs('root', [a:target]), '', 'g')
  return vcs#system(join([
        \ 'git',
        \ '--git-dir=' . vcs#vcs('root', [a:target]) . '/.git',
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
  return a:list
endfunction

