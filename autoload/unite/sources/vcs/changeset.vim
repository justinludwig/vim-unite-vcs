let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#vcs#changeset#define()
  return [s:source]
endfunction

let s:source = {
      \ 'name': 'vcs/changeset',
      \ 'description': 'vcs repository changeset.'
      \ }

function! s:source.gather_candidates(args, context)
  if !a:context.is_redraw
    let path = vcs#target(a:args)
    let revision = len(a:args) == 2 ? a:args[1] : 'HEAD'
    if vcs#detect(path) == ''
      call unite#print_message('[vcs/changeset] vcs not detected: ' . path)
      return []
    endif
    let a:context.source__path = path
    let a:context.source__revision = revision
  else
    let path = a:context.source__path
    let revision = a:context.source__revision
  endif

  let root = vcs#vcs('root', [path])
  let changeset = vcs#vcs('changeset', [path, revision])
  call unite#print_message('[vcs/changeset] root: ' . root)
  call unite#print_message('[vcs/changeset] revision: ' . changeset.revision)
  call unite#print_message('[vcs/changeset] author: ' . changeset.author)
  call unite#print_message('[vcs/changeset] date: ' . changeset.date)
  call unite#print_message('[vcs/changeset] message: ' . changeset.message)

  let statuslen = max(map(copy(changeset.changesets), "strlen(v:val.status)"))
  return map(changeset.changesets, "{
        \ 'word': s:padding(v:val.status, statuslen) . ' | ' . v:val.path[strlen(vcs#vcs('root', [v:val.path])) + 1:-1],
        \ 'action__revision': changeset.revision,
        \ 'action__prev_revision': changeset.prev_revision,
        \ 'action__author': changeset.author,
        \ 'action__status': v:val.status,
        \ 'action__path': v:val.path,
        \ 'kind': 'vcs/changeset'
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

