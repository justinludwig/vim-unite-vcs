let s:save_cpo = &cpo
set cpo&vim

let s:detect_cache = {}

function! vcs#detect(args)
  let target = vcs#escape(vcs#target(a:args))

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
  " detect vcs type.
  let target = vcs#target(a:args)
  let type = vcs#detect(target)
  if type == ''
    echoerr 'vcs can not detected: ' . target
    return
  endif

  " move current directory & do command.
  let root = {'vcs#' . type . '#root#do'}(a:args)
  let save = getcwd()

  call vcs#execute(['cd', root])
  let result = {'vcs#' . type . '#' . a:command . '#do'}(a:args)
  call vcs#execute(['cd', save])

  return result
endfunction

" TODO: refactor.
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
  let _ = type(args) == type([]) ? args[0] : args
  let target = type(_) == type([]) ? _[0] : _
  let target = fnamemodify(target, ':p')
  return target
endfunction

function! vcs#execute(list)
  execute join(a:list, ' ')
endfunction

function! vcs#escape(files)
  if type(a:files) == type([])
    return map(a:files, "escape(substitute(v:val, '\\', '/', 'g'), ' ')")
  endif
  return escape(substitute(a:files, '\\', '/', 'g'), ' ')
endfunction

function! vcs#system(list)
  return exists('g:loaded_vimproc') ? call('vimproc#system', [join(a:list, ' ')]) : call('system', [join(a:list, ' ')])
endfunction

function! vcs#diff_file_with_string(path, arg)
  call vcs#execute(['tabedit', a:path])
  diffthis

  vnew
  put!=a:arg.string
  setlocal bufhidden=delete buftype=nofile nobuflisted noswapfile nomodifiable
  call vcs#execute(['file', a:arg.name])
  diffthis
endfunction

function! vcs#diff_string_with_string(arg1, arg2)
  tabnew
  put!=a:arg1.string
  setlocal bufhidden=delete buftype=nofile nobuflisted noswapfile nomodifiable
  call vcs#execute(['file', a:arg1.name])
  diffthis

  vnew
  put!=a:arg2.string
  setlocal bufhidden=delete buftype=nofile nobuflisted noswapfile nomodifiable
  call vcs#execute(['file', a:arg2.name])
  diffthis
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

