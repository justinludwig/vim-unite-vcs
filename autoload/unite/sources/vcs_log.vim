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
  let logs = vcs#vcs('log', [path])
  let revisionlength = max(map(copy(logs), "strlen(v:val.revision)"))
  let authorlength = max(map(copy(logs), "strlen(split(v:val.author, ' ')[0])"))
  return map(logs, "{
        \ 'word': s:padding(v:val.revision, revisionlength) . ' | '. s:padding(split(v:val.author, ' ')[0], authorlength) . ' | ' . v:val.message,
        \ 'action__path': v:val.path,
        \ 'action__revision': v:val.revision,
        \ 'action__author': v:val.author,
        \ 'action__message': v:val.message,
        \ 'kind': 'vcs/log'
        \ }")
endfunction

function! s:padding(str, num)
  let strlen = strlen(a:str)
  let num = a:num
  let pad = ''
  while num - strlen > 0
    let pad = pad . ' '
    let num = num - 1
  endwhile
  return a:str . pad
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

