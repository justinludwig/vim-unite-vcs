function! vcs#svn#root#do(...)
  let path = fnamemodify(call('vcs#get_file', a:000), ':p:h')
  let prev = ''
  while finddir('.svn', path) != ''
    let prev = path
    let path = fnamemodify(path, ':p:h:h')
  endwhile
  return prev
endfunction

