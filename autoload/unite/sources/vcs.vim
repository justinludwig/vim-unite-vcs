let s:save_cpo = &cpo
set cpo&vim

" TODO: create vcs source.
function! unite#sources#vcs#define()
  return unite#sources#vcs#get_sources('vcs')
endfunction

function! unite#sources#vcs#get_sources(target)
  let target = 'autoload/unite/sources/' . a:target
  let names = map(split(globpath(&runtimepath, target . '/*.vim'), "\<NL>"), 'fnamemodify(v:val , ":t:r")')

  " collect sources.
  let sources = []
  for source in map(names, "{'unite#sources#' . substitute(a:target . '/' . v:val, '/', '#', 'g') . '#define'}()")
    let sources += source
  endfor
  return sources
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

