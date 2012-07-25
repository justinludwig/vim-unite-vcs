let s:save_cpo  = &cpo
set cpo&vim

function! unite#kinds#vcs_status#define()
  return s:kind
endfunction

let s:kind = {
      \ 'name': 'vcs/status',
      \ 'default_action': 'open',
      \ 'action_table': {},
      \ 'parents': ['vcs/file']
      \ }

let s:kind.action_table.commit = {
      \ 'description': 'vcs commit for candidate.',
      \ 'is_selectable': 1,
      \ 'is_invalidate_cache': 1,
      \ 'is_quit': 0,
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
    exec 'tabedit ' . candidate.action__path
    diffthis
    vnew
    set bufhidden=delete
    set nobuflisted
    set buftype=nofile
    set noswapfile
    let lines = split(vcs#vcs('cat', [candidate.action__path]), '\n')
    call setline(1, lines[0])
    call append('.', lines[1:-1])
    exec 'file [REMOTE: HEAD] ' . candidate.action__path
    diffthis
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

