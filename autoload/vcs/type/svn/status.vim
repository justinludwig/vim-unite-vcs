let s:save_cpo = &cpo
set cpo&vim

function! vcs#type#svn#status#do(args)
  let path = vcs#util#substitute_path_separator(get(a:args, 'path', './'))
  return vcs#type#svn#status#parse(vcs#util#system(printf('svn status --ignore-externals %s'), path))
endfunction

function! vcs#type#svn#status#parse(output)
  let list = map(split(a:output, "\n"), 'vcs#util#trim_right(v:val)')
  let list = filter(list, 'vcs#type#svn#status#is_status_line(v:val)')
  return map(list, 'vcs#type#svn#status#line2status(v:val)')
endfunction

function! vcs#type#svn#status#is_status_line(line)
  return match(strpart(a:line, 0, 7), '^[^>]*$') > -1
endfunction

function! vcs#type#svn#status#line2status(line)
  return {
        \ 'line': a:line,
        \ 'status': strpart(a:line, 0, 7),
        \ 'path': vcs#util#substitute_path_separator(strpart(a:line, 8)),
        \ }
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

