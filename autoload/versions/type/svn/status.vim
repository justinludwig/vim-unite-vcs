let s:save_cpo = &cpo
set cpo&vim

function! versions#type#svn#status#do(args)
  let path = get(a:args, 'path', './')
  let output = versions#util#system(printf('svn status --ignore-externals %s'),
        \ versions#util#substitute_path_separator(path))
  return versions#type#svn#status#parse(output)
endfunction

function! versions#type#svn#status#parse(output)
  let list = map(split(a:output, "\n"),
        \ 'versions#util#trim_right(v:val)')
  let list = filter(list,
        \ 'versions#type#svn#status#is_status_line(v:val)')
  return map(list,
        \ 'versions#type#svn#status#create_status(v:val)')
endfunction

function! versions#type#svn#status#is_status_line(line)
  return match(strpart(a:line, 0, 7), '^[^>]*$') > -1
endfunction

function! versions#type#svn#status#create_status(line)
  return {
        \ 'line': a:line,
        \ 'status': strpart(a:line, 0, 7),
        \ 'path': versions#util#substitute_path_separator(strpart(a:line, 8)),
        \ }
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

