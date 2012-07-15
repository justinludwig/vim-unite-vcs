let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#revert#do(args)
  let files = type(a:args) == type([]) ? a:args : [a:args]

  let cwd = getcwd()
  exec 'lcd ' . vcs#vcs('root', files)

  let result = ''
  for file in files
    let status = vcs#vcs('status', [file])
    if status[0].status =~ 'A\|D'
      let result = result . '\n' . substitute(vcs#system(join([
            \ 'git',
            \ 'reset',
            \ file,
            \ ])), '\r', '', 'g')
      continue
    endif
    if status[0].status =~ 'M'
      let result = result . '\n' . substitute(vcs#system(join([
            \ 'git',
            \ 'checkout',
            \ file,
            \ ])), '\r', '', 'g')
      continue
    endif
  endfor

  exec 'lcd ' . cwd
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


