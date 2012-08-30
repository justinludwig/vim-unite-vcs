let s:save_cpo = &cpo
set cpo&vim

function! vcs#svn#root#do(args)
  let target = fnamemodify(vcs#target(a:args), ':p:h')
  let prev = ''
  while finddir('.svn', vcs#escape(target) . ';') != ''
    let prev = target
    let target = fnamemodify(vcs#escape(target), ':p:h:h')
  endwhile
  return prev
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

