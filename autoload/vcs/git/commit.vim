let s:save_cpo = &cpo
set cpo&vim

let s:files = []

function! vcs#git#commit#do(args)
  let s:files = type(a:args) == type([]) ? a:args : [a:args]
  call system(join(['git', 'commit', '--include', join(vcs#escape(s:files), ' ')], ' '))
  call vcs#execute(['tabedit', '.git/COMMIT_EDITMSG'])
  call vcs#execute(['set', 'filetype=gitcommit'])

  augroup VimUniteVcsGitCommit
    autocmd!
    autocmd! BufWinEnter <buffer> setlocal bufhidden=delete nobuflisted noswapfile
    autocmd! BufWritePre <buffer> g/^#\|^\s*$/d
    autocmd! BufWinLeave <buffer> call s:commit()
  augroup END
endfunction

function! s:commit()
  let root = vcs#vcs('root', s:files)
  let save = getcwd()

  call vcs#execute(['cd', root])
  try
    let lines = substitute(vcs#system([
          \ 'git',
          \ 'commit',
          \ '--include',
          \ '-F',
          \ '.git/COMMIT_EDITMSG',
          \ join(vcs#escape(s:files), ' ')
          \ ]), '\r', '', 'g')
    for line in split(lines, "\n")
      echomsg line . "\n"
    endfor
  catch
  endtry
  call vcs#execute(['cd', save])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

