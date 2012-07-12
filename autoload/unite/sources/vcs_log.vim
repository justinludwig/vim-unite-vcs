let s:save_cpo  = &cpo
set cpo&vim

function! unite#sources#vcs_log#define()
  return s:source
endfunction

let s:source = {
      \ 'name': 'vcs/log',
      \ 'description': 'vcs repository or file log.'
      \ }

function! s:source.gather_candidates(args, context)
  let path = len(a:args) > 0 ? a:args[0] : vcs#vcs('root')
  return map(vcs#vcs('log', [path]), "{
        \ 'word': v:val.revision . ' | '. v:val.author . ' | '. v:val.message,
        \ 'action__path': v:val.path,
        \ 'action__revision': v:val.revision,
        \ 'action__author': v:val.author,
        \ 'action__message': v:val.message,
        \ 'kind': 'vcs/log'
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

