let s:save_cpo  = &cpo
set cpo&vim

function! unite#kinds#vcs_status_svn#define()
  return s:kind
endfunction

let s:kind = {
      \ 'name': 'vcs/status/svn',
      \ 'default_action': 'open',
      \ 'action_table': {},
      \ 'parents': ['vcs/status']
      \ }

let s:kind.action_table.resolve = {
      \ 'description': 'vcs resolve for candidate.',
      \ 'is_selectable': 1,
      \ 'is_invalidate_cache': 1,
      \ 'is_quit': 0,
      \ }
function! s:kind.action_table.resolve.func(candidates)
  let candidates = type(a:candidates) == type([]) ? a:candidates : [a:candidates]
  for message in split(vcs#vcs('resolve', map(copy(candidates), "v:val.action__path")), '\n')
    echomsg message
  endfor
endfunction

let s:kind.action_table.resolved = {
      \ 'description': 'vcs resolved for candidate.',
      \ 'is_selectable': 1,
      \ 'is_invalidate_cache': 1,
      \ 'is_quit': 0,
      \ }
function! s:kind.action_table.resolved.func(candidates)
  let candidates = type(a:candidates) == type([]) ? a:candidates : [a:candidates]
  for message in split(vcs#vcs('resolved', map(copy(candidates), "v:val.action__path")), '\n')
    echomsg message
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


