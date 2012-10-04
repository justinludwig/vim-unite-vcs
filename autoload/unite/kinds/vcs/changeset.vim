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

let s:kind.action_table.diff_prev = {
      \ 'description': 'diff with previous revision.',
      \ 'is_selectable': 1,
      \ }
function! s:kind.action_table.diff_prev.func(candidates)
  for candidate in a:candidates
    tabnew
    set bufhidden=delete
    set nobuflisted
    set buftype=nofile
    set noswapfile
    let lines = split(vcs#vcs('cat', [candidate.action__path, candidate.action__revision]), '\n')
    call setline(1, lines[0])
    call append('.', lines[1:-1])
    exec 'file [REMOTE1: ' . candidate.action__revision . '] ' . candidate.action__path
    setlocal nomodifiable
    diffthis

    vnew
    set bufhidden=delete
    set nobuflisted
    set buftype=nofile
    set noswapfile
    let lines = split(vcs#vcs('cat', [candidate.action__path, candidate.action__prev_revision]), '\n')
    call setline(1, lines[0])
    call append('.', lines[1:-1])
    exec 'file [REMOTE2: ' . candidate.action__prev_revision . '] ' . candidate.action__path
    setlocal nomodifiable
    diffthis
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


