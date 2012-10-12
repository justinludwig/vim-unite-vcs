let s:save_cpo = &cpo
set cpo&vim

let s:type_cache = {}
function! vcs#get_type(path)
  let path = fnamemodify(vcs#util#substitute_path_separator(a:path), ':p:h')
  if executable('git') && finddir('.git', path . ';', ':p:h:h') != ''
    let s:type_cache[path] = 'git'
  endif
  if executable('svn') && finddir('.svn', path . ';', ':p:h:h') != ''
    let s:type_cache[path] = 'svn'
  endif
  return get(s:type_cache, path, '')
endfunction

function! vcs#is_type(type, path)
  return a:type == vcs#get_type(a:path)
endfunction

function! vcs#get_root_dir(path)
  if vcs#get_type(a:path) == 'git'
    let target_dir = '.git'
  endif
  if vcs#get_type(a:path) == 'svn'
    let dir = '.svn'
  endif
  if !exists('dir')
    throw 'vcs#get_root_dir: vcs not detected.'
  endif

  let path = fnamemodify(vcs#util#substitute_path_separator(a:path), ':p')
  while finddir(dir, fnamemodify(path, ':p:h:h') . ';') != ''
    let path = fnamemodify(path, ':p:h:h')
  endwhile
  return path
endfunction

function! vcs#vcs(command, command_args, global_args)
  " get command working dir.
  let working_dir = get(vcs#util#is_dict(a:global_args) ? a:global_args : {},
        \ 'working_dir',
        \ s:get_working_dir())

  " try vcs detect.
  if vcs#get_type(working_dir) == ''
    throw 'vcs#vcs: vcs not detected.'
  endif

  " do command.
  let function_name = printf('vcs#type#%s#%s#do', vcs#get_type(working_dir), a:command)
  return s:call_with_working_dir(function_name,
        \ vcs#util#is_dict(a:command_args) ? a:command_args : {},
        \ working_dir)
endfunction

function! s:get_working_dir()
  let working_dir = expand('%')
  if exists('b:vimshell.current_dir')
    let working_dir = b:vimshell.current_dir
  endif
  if exists('b:vimfiler.current_dir')
    let working_dir = b:vimfiler.current_dir
  endif
  return fnamemodify(working_dir, ':p')
endfunction

function! s:call_with_working_dir(function_name, args, working_dir)
  let current_dir = getcwd()
  call vcs#util#execute('lcd', a:working_dir)
  try
    let result = call(a:function_name, [a:args])
  catch
    call vcs#util#execute('lcd', current_dir)
  endtry
  call vcs#util#execute('lcd', current_dir)

  if v:exception != ''
    throw v:exception
  endif
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

