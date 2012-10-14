let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#versions#git#status#define()
  return [s:source]
endfunction

let s:source = {
      \ 'name': 'versions/git/status',
      \ 'description': 'vcs repository status.',
      \ 'hooks': {},
      \ }

function! s:source.hooks.on_init(args, context)
  let a:context.source__args = a:args
endfunction

function! s:source.gather_candidates(args, context)
  let path = get(a:context.source__args, 0,
        \ versions#get_working_dir())

  call unite#print_message('[versions/status] type: ' . versions#get_type(path))
  call unite#print_message('[versions/status] path: ' . versions#get_root_dir(path))

  let statuses = versions#command('status', { 'path': versions#get_root_dir(path) }, {
        \ 'working_dir': versions#get_root_dir(path)
        \ })
  return map(statuses, "{
        \   'word': v:val.status . ' | ' . v:val.path,
        \   'action__status': v:val,
        \   'kind': 'versions/git/status',
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo


