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
  let path = len(a:args) > 0 ? call('vcs#target', a:args) : vcs#vcs('root')
  let root = vcs#vcs('root', [path])

  call unite#print_message('[vcs/status] root: ' . root)
  call unite#print_message('[vcs/status] target: ' . path[strlen(root) + 1:-1])

  return map(vcs#vcs('status', [path]), "{
        \ 'word': v:val.status . ' | '. v:val.path[strlen(vcs#vcs('root', [v:val.path])) + 1:-1],
        \ 'action__path': v:val.path,
        \ 'action__status': v:val.status,
        \ 'kind': 'vcs/status'
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

