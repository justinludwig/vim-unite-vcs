let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#versions#define()
  return [s:source] + unite#sources#versions#get_sources('versions')
endfunction

let s:source = {
      \ 'name': 'versions',
      \ 'description': 'nominates vcs sources.'
      \ }

function! s:source.gather_candidates(args, context)
  let path = get(a:args, 0,
        \ versions#get_working_dir())
  let sources = unite#sources#versions#get_sources('versions/' .
        \ versions#get_type(path))

  return map(sources, "{
        \ 'word': v:val.name,
        \ 'action__source_name': v:val.name,
        \ 'action__source_args': a:args,
        \ 'kind': 'source',
        \ }")
endfunction

function! unite#sources#versions#get_sources(target)
  let target = 'autoload/unite/sources/' . a:target
  let paths = []

  " target path loop.
  for path in split(globpath(&runtimepath, target . '/**/*.vim'))
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

