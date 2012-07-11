function! vcs#svn#log#do(...)
  let file = call('vcs#get_file', a:000)
  let str = s:system(file)
  let list = s:str2list(str)
  let list = s:extract(list)
  let list = s:parse(file, list)
  return list
endfunction

function! s:system(...)
  let file = call('vcs#get_file', a:000)
  return vcs#system(join([
        \ 'svn',
        \ 'log',
        \ '-l 50',
        \ file
        \ ], ' '))
endfunction

function! s:str2list(str)
  return split(a:str, '------------------------------------------------------------------------')
endfunction

function! s:extract(list)
  return filter(map(a:list, "split(v:val, '\n')"), "len(v:val) > 0")
endfunction

function! s:parse(file, list)
  return map(a:list, "{
        \ 'revision': split(v:val[0], '|')[0],
        \ 'author': split(v:val[0], '|')[1],
        \ 'message': v:val[2],
        \ 'path': a:file
        \ }")
endfunction

