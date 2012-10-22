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
  if !vital#versions#yesno('commit?')
    return
  endif

  g/^#\|^\s*$/d
  write!

  let current_dir = getcwd()
  call vital#versions#execute('lcd', b:versions.context.working_dir)
  try
    let output = vital#versions#system(printf('git commit -F %s -- %s',
          \ s:get_file(b:versions.context.working_dir),
          \ join(
          \   map(deepcopy(b:versions.context.args.paths),
          \     'vital#versions#substitute_path_separator(v:val)'
          \   ),
          \   ' '
          \ )))
    call vital#versions#echomsgs(vital#versions#trim_cr(output))
  finally
    call vital#versions#execute('lcd', current_dir)
  endtry
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

