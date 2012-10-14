let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#versions#svn#status#define()
  return [s:source]
endfunction

let s:source = {
      \ 'name': 'versions/svn/status',
      \ 'description': 'vcs repository status.'
      \ }

function! s:source.gather_candidates(args, context)
  if !a:context.is_redraw
  else
  endif

  call unite#print_message('[versions/status] type: ' . versions#get_type('.'))
  call unite#print_message('[versions/status] path: ' . versions#get_root_dir('.'))

  return map(versions#command('status', { 'path': '.' }, { 'working_dir': '.' }), "{
        \ 'word': v:val.status . ' | '. v:val.path,
        \ 'action__path': v:val.path,
        \ 'action__status': v:val.status,
        \ 'kind': 'versions/svn/status',
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


