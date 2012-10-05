let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#vcs#file#define()
  return [s:kind]
endfunction

let s:kind = {
      \ 'name': 'vcs/file',
      \ 'default_action': 'open',
      \ 'action_table': {},
      \ 'parents': ['file']
      \ }

let s:kind.action_table.diff = {
      \ 'is_listed': 0,
      \ }
function! s:kind.action_table.diff.func(candidates)
endfunction

let s:kind.action_table.dirdiff = {
      \ 'is_listed': 0,
      \ }
function! s:kind.action_table.dirdiff.func(candidates)
endfunction

let s:kind.action_table.log = {
      \ 'description': 'display vcs log.',
      \ 'is_selectable': 1,
      \ 'is_quit': 0
      \ }
function! s:kind.action_table.log.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  call unite#start_temporary([['vcs/log', fnamemodify(candidate.action__path, ':p:h')]])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

