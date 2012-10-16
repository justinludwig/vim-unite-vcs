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
  let a:context.source__args = {}
  let a:context.source__args.path = unite#sources#versions#get_path(get(a:args, 0, '%'))
endfunction

function! s:source.gather_candidates(args, context)
  let path = a:context.source__args.path

  if versions#get_type(path) == ''
    call unite#print_message('[versions] vcs not detected.')
    return []
  endif

  call unite#print_message('[versions/status] type: ' . versions#get_type(path))
  call unite#print_message('[versions/status] path: ' . path)

  let statuses = versions#command('status', { 'path': path }, {
        \ 'working_dir': fnamemodify(path, ':p:h')
        \ })
  return map(statuses, "{
        \   'word': v:val.status . ' | ' . v:val.path,
        \   'action__status': v:val,
        \   'kind': 'versions/git/status',
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

