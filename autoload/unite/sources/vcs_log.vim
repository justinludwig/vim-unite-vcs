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
  if vcs#detect(call('vcs#target', a:args)) == ''
    let path = len(a:args) > 0 ? call('vcs#target', a:args) : expand('%:p')
    call unite#print_message('[vcs/status] vcs not detected: ' . path)
    return []
  endif

  if !a:context.is_redraw
    let path = call('vcs#target', a:args)
    let a:context.source__path = path
  else
    let path = a:context.source__path
  endif

  let root = vcs#vcs('root', [path])
  let logs = vcs#vcs('log', [path])
  call unite#print_message('[vcs/log] root: ' . root)
  call unite#print_message('[vcs/log] target: ' . path[strlen(root) + 1:-1])

  let revisionlen = max(map(copy(logs), "strlen(v:val.revision)"))
  let authorlen = max(map(copy(logs), "strlen(split(v:val.author, ' ')[0])"))
  return map(logs, "{
        \ 'word': s:padding(v:val.revision, revisionlen) . ' | '. s:padding(split(v:val.author, ' ')[0], authorlen) . ' | ' . v:val.message,
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
