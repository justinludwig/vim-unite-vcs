let s:save_cpo = &cpo
set cpo&vim

function! vcs#util#diff#file_with_string(path, arg2)
  call vcs#util#execute('tabedit', a:path)
  diffthis

  vnew
  put!=a:arg.string
  setlocal bufhidden=delete buftype=nofile nobuflisted noswapfile nomodifiable
  call vcs#util#execute('file', a:arg.name)
  diffthis
endfunction

function! vcs#util#diff#string_with_string(arg1, arg2)
  tabnew
  put!=a:arg1.string
  setlocal bufhidden=delete buftype=nofile nobuflisted noswapfile nomodifiable
  call vcs#util#execute('file', a:arg1.name)
  diffthis

  vnew
  put!=a:arg2.string
  setlocal bufhidden=delete buftype=nofile nobuflisted noswapfile nomodifiable
  call vcs#util#execute('file', a:arg2.name)
  diffthis
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

