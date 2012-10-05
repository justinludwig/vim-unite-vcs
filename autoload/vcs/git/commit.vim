let s:save_cpo = &cpo
set cpo&vim

" TODO: refactor.

let s:files = []

function! vcs#git#commit#do(args)
  if !empty(s:files)
    echomsg 'you should finish previous commitment.'
    return
  endif

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

  let yesno = input('commit? (y/n): ')
  if yesno == 'y'
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

      echomsg ' '
      for line in split(lines, "\n")
        echomsg line
      endfor
    catch
    endtry
    call vcs#execute(['cd', save])
  endif

  let s:files = []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

