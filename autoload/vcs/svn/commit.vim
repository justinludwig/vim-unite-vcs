let s:save_cpo = &cpo
set cpo&vim

" TODO: refactor.

let s:files = []

function! vcs#svn#commit#do(args)
  if !empty(s:files)
    echomsg 'you should finish previous commitment.'
    return
  endif

  let s:files = type(a:args) == type([]) ? a:args : [a:args]
  call s:make_msgfile()
  call vcs#execute(['tabedit', g:vcs#svn#commit_msgfile])

  augroup VimUniteVcsSvnCommit
    autocmd!
    autocmd! BufWinEnter <buffer> setlocal bufhidden=wipe nobuflisted noswapfile
    autocmd! BufWritePre <buffer> execute '%s/' . g:vcs#svn#commit_ignore . '\_.*//g'
    autocmd! BufWinLeave <buffer> call s:commit()
  augroup END
endfunction

function! s:commit()
  let root = vcs#vcs('root', s:files)
  let save = getcwd()
  call vcs#execute(['cd', root])

  let yesno = input('commit? (y/n): ')
  if yesno == 'y'
    try
      let lines = vcs#system([
            \ 'svn',
            \ 'commit',
            \ '-F',
            \ g:vcs#svn#commit_msgfile,
            \ join(vcs#escape(s:files), ' ')
            \ ])

      echomsg ' '
      for line in split(lines, "\n")
        echomsg line
      endfor
    catch
    endtry
  endif
  if filereadable(g:vcs#svn#commit_msgfile)
    call delete(g:vcs#svn#commit_msgfile)
  endif
  call vcs#execute(['cd', save])

  let s:files = []
endfunction

function! s:trim_msgfile()
endfunction

function! s:make_msgfile()
  let root = vcs#vcs('root', s:files)
  let save = getcwd()

  call vcs#execute(['cd', root])
  try
    let status = map(vcs#vcs('status', s:files), "v:val.status . v:val.path[len(root) + 1:-1]")
    call writefile(['', g:vcs#svn#commit_ignore, ''] + status, g:vcs#svn#commit_msgfile)
  catch
  endtry
  call vcs#execute(['cd', save])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

