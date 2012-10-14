let s:save_cpo = &cpo
set cpo&vim

" TODO: refactor.
let s:types = [
      \ 'git',
      \ 'svn',
      \ ]

" TODO: refactor.
let s:type_dir_map = {
      \ 'git': '.git',
      \ 'svn': '.svn',
      \ }

let s:type_cache = {}

function! versions#get_type(path)
  let path = fnamemodify(versions#util#substitute_path_separator(a:path), ':p:h')
  for type in s:types
    if executable(type) && finddir(s:type_dir_map[type], path . ';', ':p:h:h') != ''
      let s:type_cache[path] = type
    endif
  endfor
  return get(s:type_cache, path, '')
endfunction

function! versions#is_type(type, path)
  return a:type == versions#get_type(a:path)
endfunction

function! versions#get_root_dir(path)
  let type = versions#get_type(a:path)
  if !exists('s:type_dir_map[type]')
    throw 'versions#get_root_dir: vcs not detected.'
  endif

  let path = fnamemodify(versions#util#substitute_path_separator(a:path), ':p')
  while finddir(s:type_dir_map[type], fnamemodify(path, ':p:h:h') . ';') != ''
    let path = fnamemodify(path, ':p:h:h')
  endwhile
  return path
endfunction

function! versions#command(command, command_args, global_args)
  " get command working dir.
  let working_dir = get(versions#util#is_dict(a:global_args) ? a:global_args : {},
        \ 'working_dir',
        \ versions#get_working_dir())

  " try versions detect.
  if versions#get_type(working_dir) == ''
    throw 'versions#command: vcs not detected.'
  endif

  " do command.
  let function_name = printf('versions#type#%s#%s#do',
        \ versions#get_type(working_dir), a:command)
  return s:call_with_working_dir(function_name,
        \ versions#util#is_dict(a:command_args) ? a:command_args : {},
        \ working_dir)
endfunction

function! versions#get_working_dir()
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
  call versions#util#execute('lcd', a:working_dir)
  try
    let result = call(a:function_name, [a:args])
  finally
    call versions#util#execute('lcd', current_dir)
  endtry
  return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

