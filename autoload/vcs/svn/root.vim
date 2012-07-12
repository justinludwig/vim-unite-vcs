let s:save_cpo  = &cpo
set cpo&vim

function! vcs#svn#root#do(...)
  let target = fnamemodify(call('vcs#target', a:000), ':p:h')
  let prev = ''
  while finddir('.svn', target . ';') != ''
    let prev = target
    let target = fnamemodify(target, ':p:h:h')
  endwhile
  return prev
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

