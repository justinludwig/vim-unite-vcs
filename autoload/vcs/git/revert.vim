let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#revert#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]
  let result = ''
  for file in files
    let status = vcs#vcs('status', [file])
    if status[0].status =~ 'A'
      let result = result . vcs#system([
            \ 'git',
            \ 'reset',
            \ vcs#escape(file),
            \ ])
      continue
    endif
    if status[0].status =~ 'D'
      let result = result . vcs#system([
            \ 'git',
            \ 'reset',
            \ 'HEAD',
            \ vcs#escape(file),
            \ ])
      if !filereadable(file)
        let result = result . vcs#system([
              \ 'git',
              \ 'checkout',
              \ vcs#escape(file),
              \ ]))
      endif
      continue
    endif
    if status[0].status =~ 'M'
      let result = result . vcs#system([
            \ 'git',
            \ 'checkout',
            \ vcs#escape(file),
            \ ])
      continue
    endif
  endfor
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

