let s:save_cpo = &cpo
set cpo&vim

let g:vcs#type#svn#log#limit = 1000
let g:vcs#type#svn#log#stop_on_copy = 1
let g:vcs#type#svn#log#separator = '------------------------------------------------------------------------'

function! vcs#type#svn#log#do(args)
  let path = get(a:args, 'path', './')
  let limit = get(a:args, 'limit', g:vcs#type#svn#log#limit)
  let stop_on_copy = get(a:args, 'stop_on_copy', g:vcs#type#svn#log#stop_on_copy)

  return vcs#type#svn#log#parse(vcs#util#system(printf('svn log --incremental --limit %s %s %s'),
        \ limit,
        \ stop_on_copy,
        \ vcs#util#substitute_path_separator(path)))
endfunction

function! vcs#type#svn#log#parse(output)
  if stridx(a:output, g:vcs#type#svn#log#separator) < 0
    return []
  endif
  let list = split(a:output, g:vcs#type#svn#log#separator)
  let list = filter(list, 'strlen(v:val)')
  let list = map(list, 'vcs#type#svn#log#lines2log(v:val)')
  let list = filter(list, '!empty(v:val)')
  return s:append_prev_revision(list)
endfunction

function! vcs#type#svn#log#lines2log(lines)
  try
    let lines = split(vcs#util#trim(a:lines), "\n")
    let description = lines[0]
    let message = join(lines[2:], "\n")
    let [revision, author, date, _] = map(split(description, "|"), 'vcs#util#trim(v:val)')
  catch
    return {}
  endtry
  return {
        \ 'revision': matchstr(revision, '\d\+'),
        \ 'message': message,
        \ 'author': author,
        \ 'date': matchstr(date, '\d\{4,4}\-\d\{2,2}-\d\{2,2}\s\d\{2,2}:\d\{2,2}:\d\{2,2}')
        \ }
endfunction

function! s:append_prev_revision(list)
  let i = 0
  while exists('a:list[i + 1]')
    let a:list[i].prev_revision = a:list[i + 1].revision
    let i += 1
  endwhile
  let a:list[i].prev_revision = ''
  return a:list
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

