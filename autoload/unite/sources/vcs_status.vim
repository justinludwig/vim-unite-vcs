function! unite#sources#vcs_status#define()
  return s:source
endfunction

let s:source = {
      \ 'name': 'vcs/status',
      \ 'description': 'vcs repository status.'
      \ }

function! s:source.gather_candidates(args, context)
  let path = len(a:args) > 0 ? a:args[0] : vcs#vcs('root')
  return map(vcs#vcs('status', [path]), "{
        \ 'word': v:val.status . ' | '. substitute(v:val.path, vcs#vcs('root', [v:val.path]), '', 'g'),
        \ 'action__path': v:val.path,
        \ 'action__status': v:val.status,
        \ 'kind': 'vcs/status'
        \ }")
endfunction

