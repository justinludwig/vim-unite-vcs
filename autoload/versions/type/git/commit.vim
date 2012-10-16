let s:save_cpo = &cpo
set cpo&vim

let g:versions#type#git#commit#filepath = '.git'
let g:versions#type#git#commit#filename = 'COMMIT_EDITMSG'
let g:versions#type#git#commit#filetype = 'gitcommit'

let s:paths = []

function! versions#type#git#commit#do(args)
  let args = a:args

  if !has_key(a:args, 'paths') || !vital#versions#is_list(a:args.paths)
    let args.paths = []
  endif

  call vital#versions#execute(['tabedit',
        \ g:versions#type#git#commit#filepath])
  call vital#versions#execute(['set', 'filetype=' .
        \ g:versions#type#git#commit#filetype])

  let s:paths = map(args.paths,
        \ 'vital#versions#substitute_path_separator(v:val)')
  call s:create_messagefile(s:paths)

  augroup VimUniteVcsGitCommit
    autocmd!
    autocmd! BufWinEnter <buffer> setlocal bufhidden=wipe nobuflisted noswapfile
    autocmd! BufWritePre <buffer> g/^#\|^\s*$/d
    autocmd! BufWinLeave <buffer> call s:commit()
  augroup END
endfunction

function! s:create_messagefile(paths)
  let filepath = printf(versions#get_root_dir(getcwd()) . '/%s/%s',
        \ g:versions#type#git#commit#filepath,
        \ g:versions#type#git#commit#filename)
  let output = vital#versions#system(printf('git commit --quiet -- %s',
        \ join(paths, ' ')))
  call writefile(filepath,
        \ [''] + split(vital#versions#trim_cr(output), "\n"))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

