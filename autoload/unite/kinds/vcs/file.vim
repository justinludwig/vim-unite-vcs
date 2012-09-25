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

let s:kind.action_table.log = {
      \ 'description': 'display vcs log.',
      \ 'is_selectable': 1
      \ }
function! s:kind.action_table.log.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  call unite#start([['vcs/log', candidate.action__path]])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

