function! vcs#git#status#do(...)
  let file = call('vcs#get_file', a:000)
  let str = s:system(file)
  let list = s:str2list(str)
  let list = s:extract(list)
  let list = s:parse(list)
  return list
endfunction

function! s:system(...)
  let file = call('vcs#get_file', a:000)
  let relative = substitute(file, vcs#root(file), '', 'g')
  return vcs#system(join([
        \ 'git',
        \ '--git-dir=' . vcs#root(file) . '/.git',
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

echo vcs#git#status#do('~/.vim/bundle/vim-neco-snippets')

