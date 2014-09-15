let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#vcs#status#define()
  return [s:kind] + unite#kinds#vcs#get_kinds('vcs/status')
endfunction

let s:kind = {
      \ 'name': 'vcs/status',
      \ 'default_action': 'diff',
      \ 'action_table': {},
      \ 'parents': ['vcs/file']
      \ }

let s:kind.action_table.commit = {
      \ 'description': 'vcs commit for candidate.',
      \ 'is_selectable': 1,
      \ 'is_invalidate_cache': 1,
      \ }
function! s:kind.action_table.commit.func(candidates)
  let candidates = type(a:candidates) == type([]) ? a:candidates : [a:candidates]
  call vcs#vcs('commit', map(candidates, "v:val.action__path"))
endfunction

let s:kind.action_table.add = {
      \ 'description': 'vcs add for candidate.',
      \ 'is_selectable': 1,
      \ 'is_invalidate_cache': 1,
      \ 'is_quit': 0,
      \ }
function! s:kind.action_table.add.func(candidates)
  let candidates = type(a:candidates) == type([]) ? a:candidates : [a:candidates]
  for message in split(vcs#vcs('add', map(copy(candidates), "v:val.action__path")), '\n')
    echomsg message
  endfor
endfunction

let s:kind.action_table.delete = {
      \ 'description': 'vcs delete for candidate.',
      \ 'is_selectable': 1,
      \ 'is_invalidate_cache': 1,
      \ 'is_quit': 0,
      \ }
function! s:kind.action_table.delete.func(candidates)
  let candidates = type(a:candidates) == type([]) ? a:candidates : [a:candidates]
  for message in split(vcs#vcs('delete', map(copy(candidates), "v:val.action__path")), '\n')
    echomsg message
  endfor
endfunction

let s:kind.action_table.revert = {
      \ 'description': 'vcs revert for candidate.',
      \ 'is_selectable': 1,
      \ 'is_invalidate_cache': 1,
      \ 'is_quit': 0,
      \ }
function! s:kind.action_table.revert.func(candidates)
  let candidates = type(a:candidates) == type([]) ? a:candidates : [a:candidates]
  for message in split(vcs#vcs('revert', map(copy(candidates), "v:val.action__path")), '\n')
    echomsg message
  endfor
endfunction

let s:kind.action_table.diff = {
      \ 'description': 'diff with remote.',
      \ 'is_selectable': 1
      \ }
function! s:kind.action_table.diff.func(candidates)
  for candidate in a:candidates
    "execute "Gdiff ../../../.." . candidate.action__path
    call vcs#diff_file_with_string(candidate.action__path, {
          \ 'name': '[REMOTE] ' . candidate.action__path,
          \ 'string': vcs#vcs('cat', [candidate.action__path])
          \ })
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

