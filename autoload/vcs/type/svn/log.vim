let s:save_cpo = &cpo
set cpo&vim

let g:vcs#type#svn#log#limit = 1000
let g:vcs#type#svn#log#stop_on_copy = 1
let g:vcs#type#svn#log#separator = '------------------------------------------------------------------------'

function! vcs#type#svn#log#do(args)
  let path = vcs#util#substitute_path_separator(get(a:args, 'path', './'))
  let limit = get(a:args, 'limit', g:vcs#type#svn#log#limit)
  let stop_on_copy = get(a:args, 'stop_on_copy', g:vcs#type#svn#log#stop_on_copy)

  return vcs#type#svn#log#parse(vcs#util#system(printf('svn log --incremental --limit %s %s %s'),
        \ limit, stop_on_copy, path))
endfunction

function! vcs#type#svn#log#parse(output)
  if stridx(a:output, g:vcs#type#svn#log#separator) < 0
    return []
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


