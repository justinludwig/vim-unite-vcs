function! vcs#git#root#do(...)
  let file = call('vcs#get_file', a:000)
  return fnamemodify(finddir('.git', file . ';'), ':p:h:h')
endfunction

