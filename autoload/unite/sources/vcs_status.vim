let s:save_cpo  = &cpo
set cpo&vim

function! unite#sources#vcs_status#define()
  return s:source
endfunction

let s:source = {
      \ 'name': 'vcs/status',
      \ 'description': 'vcs repository status.'
      \ }

function! s:source.gather_candidates(args, context)
  if !a:context.is_redraw
    let path = vcs#target(a:args)
    if vcs#detect(path) == ''
      call unite#print_message('[vcs/status] vcs not detected: ' . path)
      return []
    endif

    let a:context.source__path = path
  else
    let path = a:context.source__path
  endif

  let root = vcs#vcs('root', [path])
  call unite#print_message('[vcs/status] root: ' . root)
  call unite#print_message('[vcs/status] target: ' . path[strlen(root) + 1:-1])

  return map(vcs#vcs('status', [path]), "{
        \ 'word': v:val.status . ' | '. v:val.path[strlen(vcs#vcs('root', [v:val.path])) + 1:-1],
        \ 'source__path': path,
        \ 'action__path': v:val.path,
        \ 'action__status': v:val.status,
        \ 'kind': 'vcs/status'
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

