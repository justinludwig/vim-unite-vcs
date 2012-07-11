function! vcs#svn#status#do(...)
  let file = call('vcs#get_file', a:000)
  let str = s:system(file)
  let list = s:str2list(str)
  let list = s:extract(list)
  let list = s:parse(list)
  return list
endfunction

function! s:system(...)
  let file = call('vcs#get_file', a:000)
  return vcs#system(join([
        \ 'svn',
        \ 'status',
        \ file
        \ ], ' '))
endfunction

function! s:str2list(str)
  return split(a:str, '\n')
endfunction

function! s:extract(list)
  return filter(a:list, 'v:val =~ s:get_line_pattern()')
endfunction

function! s:parse(list)
  let list = map(a:list, "matchlist(v:val, s:get_line_pattern())")
  return map(list, "{
        \   'path': v:val[6],
        \   'status': v:val[1] . v:val[2] . v:val[3] . v:val[4] . v:val[5],
        \   'line': v:val[0]
        \ }")
endfunction

function! s:get_label(column, symbol)
  return s:symbols[a:column][a:symbol]
endfunction

function! s:get_symbols(column)
  return keys(s:symbols[a:column])
endfunction

function! s:get_line_pattern()
  return '\m^' . join(map(range(0, len(s:symbols) - 1),
        \   "'\\([' . join(s:get_symbols(v:val), '') . ']\\)'"
        \ ), '') . '\s*' . '\(.\+\)' . '$'
endfunction

let s:symbols = [{
      \   ' ' : 'NoChange',
      \   'A' : 'Added',
      \   'C' : 'Conflicted',
      \   'D' : 'Deleted',
      \   'I' : 'Ignored',
      \   'M' : 'Modified',
      \   'R' : 'Replaced',
      \   'X' : 'External',
      \   '?' : '?',
      \   '!' : '!',
      \   '~' : '~',
      \ }, {
      \   ' ' : 'NoChange',
      \   'C' : 'Conflicted',
      \   'M' : 'Modified',
      \ }, {
      \   ' ' : 'NoLock',
      \   'L' : 'Locked',
      \ }, {
      \   ' ' : 'NoSwitch',
      \   'S' : 'Switched',
      \ }, {
      \   ' ' : '',
      \   'K' : 'K',
      \   'O' : 'O',
      \   'T' : 'T',
      \   'B' : 'B',
      \ }]

