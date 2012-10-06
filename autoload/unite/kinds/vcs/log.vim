let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#vcs#log#define()
  return [s:kind] + unite#kinds#vcs#get_kinds('vcs/log')
endfunction

let s:kind = {
      \ 'name': 'vcs/log',
      \ 'default_action': 'diff_prev',
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
  call unite#start_temporary([['vcs/changeset', candidate.action__path, candidate.action__revision]])
endfunction

let s:kind.action_table.diff = {
      \ 'description': 'display candidates diff, if source path is file.',
      \ 'is_selectable': 0,
      \ 'is_quit': 0
      \ }
function! s:kind.action_table.diff.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  if filereadable(candidate.source__path)
    call vcs#diff_file_with_string(candidate.action__path, {
          \ 'name': '[REMOTE] ' . candidate.action__path,
          \ 'string': vcs#vcs('cat', [candidate.action__path, candidate.action__revision])
          \ })
  else
    call unite#start_temporary([['vcs/changeset', candidate.action__path, candidate.action__revision]])
  endif
endfunction

let s:kind.action_table.diff_prev = {
      \ 'description': 'display candidates diff previous log, if source path is file.',
      \ 'is_selectable': 0,
      \ 'is_quit': 0
      \ }
function! s:kind.action_table.diff_prev.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  if filereadable(candidate.source__path)
    call vcs#diff_string_with_string({
          \ 'name': '[REMOTE: ' . candidate.action__revision . '] ' . candidate.action__path,
          \ 'string': vcs#vcs('cat', [candidate.action__path, candidate.action__revision])
          \ }, {
          \ 'name': '[REMOTE: ' . candidate.action__prev_revision . '] ' . candidate.action__path,
          \ 'string': vcs#vcs('cat', [candidate.action__path, candidate.action__prev_revision])
          \ })
  else
    call unite#start_temporary([['vcs/changeset', candidate.action__path, candidate.action__revision]])
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

