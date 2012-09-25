let s:save_cpo = &cpo
set cpo&vim

" TODO: create vcs kind.
function! unite#kinds#vcs#define()
  return unite#kinds#vcs#get_kinds('vcs')
endfunction

function! unite#kinds#vcs#get_kinds(target)
  let target = 'autoload/unite/kinds/' . a:target
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

  " collect kinds.
  let kinds = []
  for kind in map(paths, "{'unite#kinds#' . substitute(a:target . '/' . v:val, '/', '#', 'g') . '#define'}()")
    let kinds += kind
  endfor
  return kinds
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

