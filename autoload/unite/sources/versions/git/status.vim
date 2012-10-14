let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#versions#git#status#define()
  return [s:source]
endfunction

let s:source = {
      \ 'name': 'versions/git/status',
      \ 'description': 'vcs repository status.'
      \ }

function! s:source.gather_candidates(args, context)
  let path = get(a:args, 0, versions#get_working_dir())

  call unite#print_message('[versions/status] type: ' . versions#get_type(path))
  call unite#print_message('[versions/status] path: ' . versions#get_root_dir(path))

  return map(versions#command('status',
        \ { 'path': versions#get_root_dir(path) },
        \ { 'working_dir': versions#get_root_dir(path) }), "{
        \   'word': v:val.status . ' | '. v:val.path,
        \   'action__path': v:val.path,
        \   'action__status': v:val.status,
        \   'kind': 'versions/svn/status',
        \   }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo



