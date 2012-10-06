let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#vcs#log#define()
  return [s:source]
endfunction

let s:source = {
      \ 'name': 'vcs/log',
      \ 'description': 'vcs repository or file log.'
      \ }

function! s:source.gather_candidates(args, context)
  if !a:context.is_redraw
    let path = vcs#target(a:args)
    let type = vcs#detect(path)
    if type == ''
      call unite#print_message('[vcs/log] vcs not detected: ' . path)
      return []
    endif
    let a:context.source__path = path
    let a:context.source__type = type
  else
    let path = a:context.source__path
    let type = a:context.source__type
  endif

  let root = vcs#vcs('root', [path])
  call unite#print_message('[vcs/log] root: ' . root)
  call unite#print_message('[vcs/log] target: ' . path[strlen(root) + 1:-1])

  let logs = vcs#vcs('log', [path])
  let revisionlen = max(map(copy(logs), "strlen(v:val.revision)"))
  let datelen = max(map(copy(logs), "strlen(split(v:val.date, ' ')[0])"))
  let authorlen = max(map(copy(logs), "strlen(split(v:val.author, ' ')[0])"))

  let kind = 'vcs/log'
  if len(keys(unite#get_kinds(kind . '/' . type))) > 0
    let kind = kind . '/' . type
  endif
  return map(logs, "{
        \ 'word': s:padding(v:val.revision, revisionlen) . ' | '. s:padding(v:val.date, datelen) . ' | '. s:padding(v:val.author, authorlen) . ' | ' . v:val.message,
        \ 'source__path': path,
        \ 'action__path': v:val.path,
        \ 'action__revision': v:val.revision,
        \ 'action__prev_revision': v:val.prev_revision,
        \ 'action__author': v:val.author,
        \ 'action__message': v:val.message,
        \ 'kind': kind
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

