let s:save_cpo = &cpo
set cpo&vim

function! versions#type#svn#commit#do(args)
  if !has_key(a:args, 'paths') || !versions#util#is_list(a:args.paths)
    throw 'versions#type#svn#commit: invalid argument "paths".'
  endif
  return map(a:args.paths, 'versions#util#substitute_path_separator(v:val)')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

