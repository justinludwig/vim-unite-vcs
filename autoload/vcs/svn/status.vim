let s:save_cpo = &cpo
set cpo&vim

function! vcs#svn#status#do(args)
  let target = vcs#target(a:args)
  let str = s:system(target)
  let list = s:str2list(str)
  let list = s:extract(list)
  return s:parse(list)
endfunction

function! s:system(target)
  return vcs#system([
        \ 'svn',
        \ 'status',
        \ vcs#escape(a:target)
        \ ])
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
        \   'path': v:val[8],
        \   'status': v:val[1] . v:val[2] . v:val[3] . v:val[4] . v:val[5] . v:val[6] . v:val[7],
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
      \   ' ' : ' ',
      \   '+' : '+',
      \ }, {
      \   ' ' : 'NoSwitch',
      \   'S' : 'Switched',
      \ }, {
      \   ' ' : ' ',
      \   'K' : 'K',
      \   'O' : 'O',
      \   'T' : 'T',
      \   'B' : 'B',
      \ }, {
      \   ' ' : ' ',
      \   'C' : 'Tree Conflicted',
      \   '*' : '*'
      \ }]

let &cpo = s:save_cpo
unlet s:save_cpo

