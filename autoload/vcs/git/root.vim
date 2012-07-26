let s:save_cpo  = &cpo
set cpo&vim

function! vcs#git#root#do(args)
  let target = vcs#target(a:args)
  return fnamemodify(finddir('.git', vcs#escape(target) . ';'), ':p:h:h')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

