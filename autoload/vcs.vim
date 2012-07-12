let s:save_cpo  = &cpo
set cpo&vim

let s:detect_cache = {}

function! vcs#detect(...)
  let target = call('vcs#target', a:000)

  if exists('s:detect_cache[target]')
    return s:detect_cache[target]
  endif

  " try detect.
  if executable('git') && finddir('.git', target . ';', ':p:h:h') != ''
    let s:detect_cache[target] = 'git'
    return 'git'
  endif
  if executable('svn') && finddir('.svn', target . ';', ':p:h:h') != ''
    let s:detect_cache[target] = 'svn'
    return 'svn'
  endif
  echoerr 'vcs can not detected.'
endfunction

function! vcs#vcs(command, ...)
  let args = a:0 == 1 ? a:1 : []

  let target = call('vcs#target', args)
  let type = vcs#detect(target)
  return call('vcs#' . type . '#' . a:command . '#do', args)
endfunction

function! vcs#target(...)
  let arg = a:0 > 0 ? a:1 : expand('%')
  let target = type(arg) == type([]) ? arg[0] : arg
  let target = escape(fnamemodify(target, ':p'), ' ')
  return target
endfunction

function! vcs#system(...)
  return exists('g:loaded_vimproc') ? call('vimproc#system', a:000) : call('system', a:000)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

