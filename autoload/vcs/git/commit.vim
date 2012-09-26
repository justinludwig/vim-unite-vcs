let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#commit#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]

  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', files)
  if match(vcs#system('echo $EDITOR'), '\w\+') != -1 || match(vcs#system('echo $GIT_EDITOR'), '\w\+') != -1
    exec join([
          \ '!',
          \ 'git',
          \ 'commit',
          \ '--include',
          \ join(vcs#escape(files), ' ')
          \ ], ' ')
  else
    echomsg "can't find $EDITOR or $GIT_EDITOR variable."
    let msg = input('commit message: ')
    if msg != ''
      exec join([
            \ '!',
            \ 'git',
            \ 'commit',
            \ '--include',
            \ '-m',
            \ '"' . msg . '"',
            \ join(vcs#escape(files), ' ')
            \ ], ' ')
    endif
  endif
  exec 'lcd ' . cwd
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

