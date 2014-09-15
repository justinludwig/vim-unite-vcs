let s:save_cpo = &cpo
set cpo&vim

" TODO: create vcs kind.
function! unite#kinds#vcs#define()
  return unite#kinds#vcs#get_kinds('vcs')
endfunction

function! unite#kinds#vcs#get_kinds(target)
  let target = 'autoload/unite/kinds/' . a:target
  let names = map(split(globpath(&runtimepath, target . '/*.vim'), "\<NL>"), 'fnamemodify(v:val , ":t:r")')

  " collect kinds.
  let kinds = []
  for kind in map(names, "{'unite#kinds#' . substitute(a:target . '/' . v:val, '/', '#', 'g') . '#define'}()")
    let kinds += kind
  endfor
  return kinds
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

