function! vcs#git#root#do(...)
  let target = call('vcs#target', a:000)
  return fnamemodify(finddir('.git', target . ';'), ':p:h:h')
endfunction
