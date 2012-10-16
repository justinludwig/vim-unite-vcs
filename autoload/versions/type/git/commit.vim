let s:save_cpo = &cpo
set cpo&vim

function! versions#type#git#commit#do(args)
  if !has_key(a:args, 'paths') || !vital#versions#is_list(a:args.paths)
    throw 'versions#type#git#commit: invalid argument "paths".'
  endif
  let paths = map(a:args.paths, 'vital#versions#substitute_path_separator(v:val)')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

