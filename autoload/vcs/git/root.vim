let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#root#do(...)
  let target = call('vcs#target', a:000)
  return fnamemodify(finddir('.git', target . ';'), ':p:h:h')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

