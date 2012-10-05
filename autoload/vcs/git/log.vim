let s:save_cpo = &cpo
set cpo&vim

function! vcs#git#log#do(args)
  let cwd = getcwd()
  exec 'cd ' . vcs#vcs('root', a:args)

  let target = vcs#target(a:args)
  let str = s:system(target)
  let list = s:str2list(str)
  let result = s:parse(target, list)

  exec 'cd ' . cwd
  return result
endfunction

function! s:system(target)
  return vcs#system(join([
        \ 'git',
        \ 'log',
        \ '--pretty=format:"' . g:vcs#git#log_format . '"',
        \ vcs#escape(a:target)
        \ ], ' '))
endfunction

function! s:str2list(str)
  return map(split(a:str, "\n"), "split(v:val, '\\t')")
endfunction

function! s:parse(target, list)
  return map(a:list, '{
        \ "revision": v:val[0],
        \ "prev_revision": v:val[1],
        \ "author": v:val[2],
        \ "date": join(split(v:val[4], " ")[0:1], " "),
        \ "message": v:val[5],
        \ "path": a:target
        \ }')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

