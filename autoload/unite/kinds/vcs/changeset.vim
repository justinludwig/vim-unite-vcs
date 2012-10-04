let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#vcs#changeset#define()
  return [s:kind]
endfunction

let s:kind = {
      \ 'name': 'vcs/changeset',
      \ 'default_action': 'diff_prev',
      \ 'action_table': {},
      \ 'parents': ['vcs/file']
      \ }

let s:kind.action_table.diff = {
      \ 'description': 'diff with original.',
      \ 'is_selectable': 1,
      \ }
function! s:kind.action_table.diff.func(candidates)
  for candidate in a:candidates
    call vcs#diff_file_with_string(candidate.action__path, {
          \ 'name': '[REMOTE]' . candidate.action__path,
          \ 'string': vcs#vcs('cat', [candidate.action__path, candidate.action__revision])
          \ })
  endfor
endfunction

let s:kind.action_table.diff_prev = {
      \ 'description': 'diff with previous revision.',
      \ 'is_selectable': 1,
      \ }
function! s:kind.action_table.diff_prev.func(candidates)
  for candidate in a:candidates
    call vcs#diff_string_with_string({
          \ 'name': '[REMOTE:' . candidate.action__revision . ']' . candidate.action__path,
          \ 'string': vcs#vcs('cat', [candidate.action__path, candidate.action__revision])
          \ }, {
          \ 'name': '[REMOTE:' . candidate.action__prev_revision . ']' . candidate.action__path,
          \ 'string': vcs#vcs('cat', [candidate.action__path, candidate.action__prev_revision])
          \ }
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


