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
    let type = vcs#detect(path)
    if type == ''
      call unite#print_message('[vcs/status] vcs not detected: ' . path)
      return []
    endif
    let path = len(a:args) > 0 ? path : vcs#vcs('root', [path])
    let a:context.source__path = path
    let a:context.source__type = type
  else
    let path = a:context.source__path
    let type = a:context.source__type
  endif

  let root = vcs#vcs('root', [path])
  call unite#print_message('[vcs/status] type: ' . type)
  call unite#print_message('[vcs/status] root: ' . root)
  call unite#print_message('[vcs/status] target: ' . path[strlen(root) + 1:-1])

  let kind = 'vcs/status'
  if len(keys(unite#get_kinds(kind . '/' . type))) > 0
    let kind = kind . '/' . type
  endif
  return map(vcs#vcs('status', [path]), "{
        \ 'word': v:val.status . ' | '. v:val.path[strlen(vcs#vcs('root', [v:val.path])) + 1:-1],
        \ 'source__path': path,
        \ 'action__path': v:val.path,
        \ 'action__status': v:val.status,
        \ 'kind': kind
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

