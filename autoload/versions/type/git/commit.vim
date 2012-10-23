let s:save_cpo = &cpo
set cpo&vim

call vital#versions#define(g:, 'versions#type#git#commit#filepath', '.git')
call vital#versions#define(g:, 'versions#type#git#commit#filename', 'COMMIT_EDITMSG')
call vital#versions#define(g:, 'versions#type#git#commit#filetype', 'gitcommit')

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
    autocmd! BufWritePost <buffer> call s:commit()
  augroup END
endfunction

function! s:commit()
  if !exists('b:versions') || !exists('b:versions.context')
    throw 'versions#type#git#commit: context variable is not found.'
  endif
  if b:versions.context.type != 'git' || b:versions.context.command != 'commit'
    throw "versions#type#git#commit: context type is'nt \"commit\"."
  endif

  if !vital#versions#yesno('commit?')
    return
  endif

  call versions#call(function('s:_commit'),
        \   b:versions.context.args,
        \   b:versions.context.working_dir
        \ )
endfunction

function! s:_commit(args)
  global/^#\|^\s*$/d
  write!

  let output = vital#versions#system(printf('git commit -F %s -- %s',
        \ s:get_file(getcwd()),
        \ join(
        \   map(deepcopy(a:args.paths),
        \     'vital#versions#substitute_path_separator(v:val)'
        \   ),
        \   ' '
        \ )))
  call vital#versions#echomsgs(vital#versions#trim_cr(output))
endfunction

function! s:get_file(dir)
  return printf('%s/%s/%s',
        \   versions#get_root_dir(a:dir),
        \   g:versions#type#git#commit#filepath,
        \   g:versions#type#git#commit#filename
        \ )
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

