let s:save_cpo = &cpo
set cpo&vim

call vital#versions#define(g:, 'versions#type#svn#commit#filename', 'svn-commit.tmp')
call vital#versions#define(g:, 'versions#type#svn#commit#editorcmd', 'vim')
call vital#versions#define(g:, 'versions#type#svn#commit#ignore',
      \ '--This line, and those below, will be ignored--')

let s:paths = []

function! versions#type#svn#commit#do(args)
  if filereadable(s:get_file(getcwd()))
    call delete(s:get_file(getcwd()))
  endif

  " TODO: haa...
  call system(printf('svn commit --editor-cmd=%s %s',
        \ g:versions#type#svn#commit#editorcmd,
        \ join(
        \   map(deepcopy(a:args.paths),
        \     'vital#versions#substitute_path_separator(v:val)'
        \   ),
        \   ' '
        \ )))

  call vital#versions#execute('tabedit', s:get_file(getcwd()))

  let b:versions = {
        \ 'context': {
        \   'type': 'svn',
        \   'command': 'commit',
        \   'args': a:args,
        \   'working_dir': getcwd(),
        \   }
        \ }

  augroup VersionsSvnCommit
    autocmd!
    autocmd! BufWinEnter <buffer> setlocal bufhidden=wipe nobuflisted noswapfile
    autocmd! BufWritePre <buffer> execute '%s/' . g:versions#type#svn#commit#ignore . '\_.*//g'
    autocmd! BufWritePost <buffer> call versions#type#svn#commit#finish()
  augroup END
endfunction

function! versions#type#svn#commit#finish()
  if !exists('b:versions.context.args')
    throw 'versions#type#svn#commit: b:versions.context.args is not found.'
  endif
  if !exists('b:versions.context.working_dir')
    throw 'versions#type#svn#commit: b:versions.context.working_dir is not found.'
  endif
  if exists('b:versions.context.type') && b:versions.context.type != 'svn'
    throw 'versions#type#svn#commit: invalid b:versions.context.type.'
  endif
  if exists('b:versions.context.command') && b:versions.context.command != 'commit'
    throw 'versions#type#svn#commit: invalid b:versions.context.command.'
  endif

  if !vital#versions#yesno('commit?')
    return
  endif

  call versions#call(function(printf('<SNR>%d_commit', s:SID())),
        \ b:versions.context.args,
        \ b:versions.context.working_dir)
endfunction

function! s:commit(args)
  let output = vital#versions#system(printf('svn commit -F %s %s',
        \ s:get_file(getcwd()),
        \ join(
        \   map(deepcopy(a:args.paths),
        \     'vital#versions#substitute_path_separator(v:val)'
        \   ),
        \   ' '
        \ )))
  call delete(s:get_file(getcwd()))
  call vital#versions#echomsgs(output)
endfunction

function! s:get_file(dir)
  return printf('%s/%s',
        \   versions#get_root_dir(a:dir),
        \   g:versions#type#svn#commit#filename
        \ )
endfunction

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

