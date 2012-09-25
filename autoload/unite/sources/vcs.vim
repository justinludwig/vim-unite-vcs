let s:save_cpo = &cpo
set cpo&vim

" TODO: create vcs source.
function! unite#sources#vcs#define()
  return unite#sources#vcs#get_sources('vcs')
endfunction

function! unite#sources#vcs#get_sources(target)
  let target = 'autoload/unite/sources/' . a:target
  let paths = []

  " target path loop.
  for path in split(globpath(&runtimepath, target . '/*.vim'))
    let path = substitute(path, '\/\/', '/', 'g')

    " rtp path loop.
    for rtp in split(&runtimepath, ',')
      let rtp = substitute(rtp, '\/\/', '/', 'g') . '/' . target

      if path =~# rtp
        let l1 = strlen(path)
        let l2 = strlen(rtp)
        call add(paths, strpart(path, l2 + 1, l1 - l2 - strlen('.vim') - 1))
      endif
    endfor
  endfor

  " collect sources.
  let sources = []
  for source in map(paths, "{'unite#sources#' . substitute(a:target . '/' . v:val, '/', '#', 'g') . '#define'}()")
    let sources += source
  endfor
  return sources
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

