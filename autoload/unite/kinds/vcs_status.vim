function! unite#kinds#vcs_status#define()
  return s:kind
endfunction

let s:kind = {
      \ 'name': 'vcs/status',
      \ 'default_action': 'open',
      \ 'action_table': {},
      \ 'parents': ['file']
      \ }

let s:kind.action_table.commit = {
      \ 'description': 'vcs commit for candidate.',
      \ 'is_selectable': 1
      \ }
function! s:kind.action_table.commit.func(candidates)
  call vcs#commit(map(a:candidates, "v:val.action__path")
endfunction

let s:kind.action_table.add = {
      \ 'description': 'vcs add for candidate.',
      \ 'is_selectable': 1
      \ }
function! s:kind.action_table.add.func(candidates)
  call vcs#add(map(a:candidates, "v:val.action__path")
endfunction

let s:kind.action_table.delete = {
      \ 'description': 'vcs delete for candidate.',
      \ 'is_selectable': 1
      \ }
function! s:kind.action_table.delete.func(candidates)
  call vcs#delete(map(a:candidates, "v:val.action__path")
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
    set bufhidden
    set nobuflisted
    set buftype=nofile
    set noswapfile
    call append('$', split(vcs#vcs('cat', [candidate.action__path]), '\n'))
    call feedkeys('dd')
    diffthis
  endfor
endfunction

let s:kind.action_table.log = {
      \ 'description': 'display candidate log.',
      \ 'is_selectable': 1
      \ }
function! s:kind.action_table.log.func(candidates)
  let candidate = type(a:candidates) == type([]) ? a:candidates[0] : a:candidates
  call unite#start([['vcs/log', candidate.action__path]])
endfunction

