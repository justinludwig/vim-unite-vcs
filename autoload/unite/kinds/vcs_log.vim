let s:save_cpo  = &cpo
set cpo&vim

function! unite#kinds#vcs_log#define()
  return s:kind
endfunction

let s:kind = {
      \ 'name': 'vcs/log',
      \ 'default_action': 'diff',
      \ 'action_table': {},
      \ 'parents': ['file']
      \ }

let s:kind.action_table.diff = {
      \ 'description': 'diff with original.',
      \ 'is_selectable': 1
      \ }
function! s:kind.action_table.diff.func(candidates)
  if len(a:candidates) > 2
    echomsg 'invalid candidates length.'
    return
  endif

  " for diff original.
  let candidate = a:candidates[0]
  if len(a:candidates) == 1
    exec 'tabedit ' . candidate.action__path
    diffthis
    vnew
    set bufhidden
    set nobuflisted
    set buftype=nofile
    set noswapfile
    let lines = split(vcs#vcs('cat', [candidate.action__path, candidate.action__revision]), '\n')
    call setline(1, lines[0])
    call append('.', lines[1:-1])
    diffthis
    return
  endif

  tabnew
  set bufhidden
  set nobuflisted
  set buftype=nofile
  set noswapfile
  let lines = split(vcs#vcs('cat', [candidate.action__path, candidate.action__revision]), '\n')
  call setline(1, lines[0])
  call append('.', lines[1:-1])
  diffthis

  let candidate_ = a:candidates[1]
  vnew
  set bufhidden
  set nobuflisted
  set buftype=nofile
  set noswapfile
  let lines = split(vcs#vcs('cat', [candidate_.action__path, candidate_.action__revision]), '\n')
  call setline(1, lines[0])
  call append('.', lines[1:-1])
  diffthis
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

