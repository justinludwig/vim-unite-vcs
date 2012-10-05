let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#vcs#log#define()
  return [s:kind]
endfunction

let s:kind = {
      \ 'name': 'vcs/log',
      \ 'default_action': 'changeset',
      \ 'action_table': {},
      \ 'parents': ['vcs/file']
      \ }

let s:kind.action_table.yank_comment = {
      \ 'description': 'yank commit message.',
      \ 'is_selectable': 0,
      \ }
function! s:kind.action_table.yank_comment.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  let @" = candidate.action__message
  if has('clipboard')
    let @* = @"
  endif
endfunction

let s:kind.action_table.yank_revision = {
      \ 'description': 'yank revision.',
      \ 'is_selectable': 0,
      \ }
function! s:kind.action_table.yank_revision.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  let @" = candidate.action__revision
  if has('clipboard')
    let @* = @"
  endif
endfunction

let s:kind.action_table.changeset = {
      \ 'description': 'display changeset.',
      \ 'is_selectable': 0,
      \ 'is_quit': 0
      \ }
function! s:kind.action_table.changeset.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  call unite#start_temporary([['vcs/changeset', fnamemodify(candidate.action__path, ':p:h'), candidate.action__revision]])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

