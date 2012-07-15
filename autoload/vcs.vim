let s:save_cpo  = &cpo
set cpo&vim

let s:detect_cache = {}

function! vcs#detect(args)
  let target = vcs#target(a:args)

  if exists('s:detect_cache[target]')
    return s:detect_cache[target]
  endif

  if executable('git') && finddir('.git', target . ';', ':p:h:h') != ''
    let s:detect_cache[target] = 'git'
    return 'git'
  endif
  if executable('svn') && finddir('.svn', target . ';', ':p:h:h') != ''
    let s:detect_cache[target] = 'svn'
    return 'svn'
  endif
  return ''
endfunction

function! vcs#vcs(command, args)
  let target = vcs#target(a:args)
  let type = vcs#detect(target)
  if type == ''
    echoerr 'vcs can not detected: ' . target
    return
  endif
  return {'vcs#' . type . '#' . a:command . '#do'}(a:args)
endfunction

function! vcs#target(args)
  if type(a:args) == type([])
    let args = a:args
    if len(args) == 0
      let args = [expand('%')]

      let filetype = getbufvar(bufnr('%'), '&filetype')
      if filetype == 'vimshell'
        let args = [b:vimshell.current_dir]
      endif
      if filetype == 'vimfiler'
        let args = [b:vimfiler.current_dir]
      endif
    endif
  else
    let args = [a:args]
  endif
  let target = type(args) == type([]) ? args[0] : args
  let target = escape(fnamemodify(target, ':p'), ' ')
  return target
endfunction

function! vcs#system(...)
  return exists('g:loaded_vimproc') ? call('vimproc#system', a:000) : call('system', a:000)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

