" common.
" 
let s:detect_file_cache = {}
function! vcs#detect(...)
  let file = call('vcs#get_file', a:000)

  " get cache.
  if exists('s:detect_file_cache[file]')
    return s:detect_file_cache[file]
  endif

  " try detect.
  if executable('git') && finddir('.git', file . ';', ':p:h:h') != ''
    let s:detect_file_cache[file] = 'git'
    return 'git'
  endif
  if executable('svn') && finddir('.svn', file . ';', ':p:h:h') != ''
    let s:detect_file_cache[file] = 'svn'
    return 'svn'
  endif
  echoerr 'vcs can not detected.'
endfunction

" action.

function! vcs#root(...)
  let file = call('vcs#get_file', a:000)
  let vcs = vcs#detect(file)
  return call('vcs#' . vcs . '#root#do', a:000)
endfunction

function! vcs#cat(...)
  let file = call('vcs#get_file', a:000)
  let vcs = vcs#detect(file)
  return call('vcs#' . vcs . '#cat#do', a:000)
endfunction

function! vcs#status(...)
  let file = call('vcs#get_file', a:000)
  let vcs = vcs#detect(file)
  return call('vcs#' . vcs . '#status#do', a:000)
endfunction

function! vcs#log(...)
  let file = call('vcs#get_file', a:000)
  let vcs = vcs#detect(file)
  return call('vcs#' . vcs . '#log#do', a:000)
endfunction

" util.

function! vcs#get_file(...)
  let file = a:0 > 0 ? a:1 : expand('%')
  let file = escape(fnamemodify(file, ':p'), ' ')
  return file
endfunction

function! vcs#system(...)
  return exists('g:loaded_vimproc') ? call('vimproc#system', a:000) : call('system', a:000)
endfunction

