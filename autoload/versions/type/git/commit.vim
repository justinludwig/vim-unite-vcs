let s:save_cpo = &cpo
set cpo&vim

let g:versions#type#git#commit#filepath = '.git'
let g:versions#type#git#commit#filename = 'COMMIT_EDITMSG'
let g:versions#type#git#commit#filetype = 'gitcommit'

let s:paths = []

function! versions#type#git#commit#do(args)
  call vital#versions#execute('tabedit', s:get_file(getcwd()))
  call vital#versions#execute('set', 'filetype=' . g:versions#type#git#commit#filetype)

  let output = vital#versions#system(printf('git commit --dry-run --quiet -- %s',
        \ join(
        \   map(deepcopy(a:args.paths),
        \     'vital#versions#substitute_path_separator(v:val)'
        \   ),
        \   ' '
        \ )))

  silent % delete _
  put=output

  let b:versions = {
        \ 'context': {
        \   'type': 'git',
        \   'command': 'commit',
        \   'args': a:args,
        \   'working_dir': getcwd(),
        \   }
        \ }

  augroup VersionsGitCommit
    autocmd!
    autocmd! BufWinEnter <buffer> setlocal bufhidden=wipe nobuflisted noswapfile
    autocmd! BufWritePre <buffer> g/^#\|^\s*$/d
    autocmd! BufWritePost <buffer> call versions#type#git#commit#finish()
  augroup END
endfunction

function! versions#type#git#commit#finish()
  if !exists('b:versions.context.args')
    throw 'versions#type#git#commit: b:versions.context.args is not found.'
  endif
  if !exists('b:versions.context.working_dir')
    throw 'versions#type#git#commit: b:versions.context.working_dir is not found.'
  endif
  if exists('b:versions.context.type') && b:versions.context.type != 'git'
    throw 'versions#type#git#commit: invalid b:versions.context.type.'
  endif
  if exists('b:versions.context.command') && b:versions.context.command != 'commit'
    throw 'versions#type#git#commit: invalid b:versions.context.command.'
  endif

  if !vital#versions#yesno('commit?')
    return
  endif

  call versions#call(function(printf('<SNR>%d_commit', s:SID())),
        \ b:versions.context.args,
        \ b:versions.context.working_dir)
endfunction

function! s:commit(args)
  let output = vital#versions#system(printf('git commit -F %s -- %s',
        \ s:get_file(getcwd()),
        \ join(
        \   map(deepcopy(a:args.paths),
        \     'vital#versions#substitute_path_separator(v:val)'
        \   ),
        \   ' '
        \ )))
endfunction

function! s:get_file(dir)
  return printf('%s/%s/%s',
        \   versions#get_root_dir(a:dir),
        \   g:versions#type#git#commit#filepath,
        \   g:versions#type#git#commit#filename
        \ )
endfunction

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

