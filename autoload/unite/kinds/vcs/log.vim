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
      \ }
function! s:kind.action_table.changeset.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  call unite#start([['vcs/changeset', candidate.action__path, candidate.action__revision]])
endfunction

let s:kind.action_table.diff = {
      \ 'description': 'diff with original.',
      \ 'is_selectable': 1,
      \ }
function! s:kind.action_table.diff.func(candidates)
  if len(a:candidates) > 2
    echomsg 'invalid candidates length.'
    return
  endif

  if len(a:candidates) == 1
    call vcs#diff_file_with_string(a:candidates[0].action__path, {
          \ 'name': '[REMOTE]' . a:candidates[0].action__path,
          \ 'string': vcs#vcs('cat', [a:candidates[0].action__path, a:candidates[0].action__revision])
          \ })
    return
  else
    call vcs#diff_string_with_string({
          \ 'name': '[REMOTE:' . a:candidates[0].action__revision . ']' . a:candidates[0].action__path,
          \ 'string': vcs#vcs('cat', [a:candidates[0].action__path, a:candidates[0].action__revision])
          \ }, {
          \ 'name': '[REMOTE:' . a:candidates[1].action__revision . ']' . a:candidates[1].action__path,
          \ 'string': vcs#vcs('cat', [a:candidates[1].action__path, a:candidates[1].action__revision])
          \ }
  endif
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

