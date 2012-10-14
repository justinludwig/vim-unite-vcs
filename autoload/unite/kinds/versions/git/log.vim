let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#versions#git#log#define()
  return [s:kind]
endfunction

let s:kind = {
      \ 'name': 'versions/git/log',
      \ 'default_action': 'diff_prev',
      \ 'action_table': {},
      \ }

let s:kind.action_table.yank_message = {
      \ 'description': 'yank commit message.',
      \ 'is_selectable': 0,
      \ }
function! s:kind.action_table.yank_message.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  let @" = candidate.action__log.message
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
  let @" = candidate.action__log.revision
  if has('clipboard')
    let @* = @"
  endif
endfunction

let s:kind.action_table.yank_prev_revision = {
      \ 'description': 'yank prev_revision.',
      \ 'is_selectable': 0,
      \ }
function! s:kind.action_table.yank_prev_revision.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  let @" = candidate.action__log.prev_revision
  if has('clipboard')
    let @* = @"
  endif
endfunction

let s:kind.action_table.diff = {
      \ 'description': 'display diff.',
      \ 'is_selectable': 0,
      \ 'is_quit': 0
      \ }
function! s:kind.action_table.diff.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates

  if !filereadable(candidate.source__path)
    return unite#start_temporary([['versions/git/changeset',
          \ candidate.source__args.path,
          \ candidate.action__revision]])
  endif

  call versions#util#diff#file_with_string(candidate.action__log.path, {
        \ 'name': printf('[REMOTE] %s', candidate.action__log.path),
        \ 'string': versions#command('cat', [
        \   candidate.action__log.path,
        \   candidate.action__log.revision])})
endfunction

let s:kind.action_table.diff_prev = {
      \ 'description': 'display previous revision diff.',
      \ 'is_selectable': 0,
      \ 'is_quit': 0
      \ }
function! s:kind.action_table.diff_prev.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates

  if !filereadable(candidate.source__path)
    return unite#start_temporary([['versions/git/changeset',
          \ candidate.action__path,
          \ candidate.action__revision]])
  endif

  call versions#diff#string_with_string({
        \ 'name': printf('[REMOTE: %s] %s',
        \   candidate.action__revision,
        \   candidate.action__path),
        \ 'string': versions#command('cat', [
        \   candidate.action__path,
        \   candidate.action__revision])}, {
        \ 'name': printf('[REMOTE: %s] %s',
        \   candidate.action__prev_revision,
        \   candidate.action__path),
        \ 'string': versions#command('cat', [
        \   candidate.action__path,
        \   candidate.action__prev_revision])})
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


