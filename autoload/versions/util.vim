let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('versions')

function! versions#util#is_numeric(...)
  return call(s:V.is_numeric, a:000)
endfunction

function! versions#util#is_integer(...)
  return call(s:V.is_integer, a:000)
endfunction

function! versions#util#is_float(...)
  return call(s:V.is_float, a:000)
endfunction

function! versions#util#is_string(...)
  return call(s:V.is_string, a:000)
endfunction

function! versions#util#is_funcref(...)
  return call(s:V.is_funcref, a:000)
endfunction

function! versions#util#is_list(...)
  return call(s:V.is_list, a:000)
endfunction

function! versions#util#is_dict(...)
  return call(s:V.is_dict, a:000)
endfunction

function! versions#util#substitute_path_separator(...)
  return call(s:V.substitute_path_separator, a:000)
endfunction

function! versions#util#system(...)
  return call(s:V.system, a:000)
endfunction

function! versions#util#execute(...)
  execute join(a:000, ' ')
endfunction

function! versions#util#trim(...)
  return versions#util#trim_right(versions#util#trim_left(a:000[0]))
endfunction

function! versions#util#trim_right(...)
  return substitute(a:000[0], '\s*$', '', 'g')
endfunction

function! versions#util#trim_left(...)
  return substitute(a:000[0], '^\s*', '', 'g')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

