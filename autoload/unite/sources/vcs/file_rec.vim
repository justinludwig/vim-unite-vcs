let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#vcs#file_rec#define()
  return [s:source]
endfunction

let s:source = {
      \ 'name': 'vcs/file_rec',
      \ 'description': 'vcs repository files.'
      \ }

function! s:source.gather_candidates(args, context)
  if !a:context.is_redraw
    let path = vcs#target(a:args)
    if vcs#detect(path) == ''
      call unite#print_message('[vcs/file_rec] vcs not detected: ' . path)
      return []
    endif
    let path = len(a:args) > 0 ? path : vcs#vcs('root', [path])
    let a:context.source__path = path
  else
    let path = a:context.source__path
  endif

  let statuses = vcs#vcs('status', [path])
  let status_map = {}
  for status in statuses
    let status_map[status.path] = status.status
  endfor

  let statuslen = max(map(statuses, 'strlen(v:val.status)'))
  return map(unite#get_candidates([['file_rec', path]]), "{
        \ 'word': s:padding(exists('status_map[v:val.action__path]') ? status_map[v:val.action__path] : '', statuslen) . ' | ' . v:val.word,
        \ 'action__path': v:val.action__path,
        \ 'kind': exists('status_map[v:val.action__path]') ? 'vcs/status' : 'vcs/file'
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

