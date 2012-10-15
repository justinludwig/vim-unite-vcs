let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#versions#svn#log#define()
  return [s:source]
endfunction

let s:source = {
      \ 'name': 'versions/svn/log',
      \ 'description': 'vcs repository log.',
      \ 'hooks': {},
      \ }

function! s:source.hooks.on_init(args, context)
  let a:context.source__args = {}
  let a:context.source__args.path = get(a:args, 0, versions#get_working_dir())
  let a:context.source__args.limit = get(a:args, 1, '')
endfunction

function! s:source.gather_candidates(args, context)
  let path = a:context.source__args.path
  let limit = a:context.source__args.limit

  call unite#print_message('[versions/log] type: ' . versions#get_type(path))
  call unite#print_message('[versions/log] path: ' . versions#get_root_dir(path))

  let logs = versions#command('log', {
        \   'path': versions#get_root_dir(path),
        \   'limit': limit
        \ }, {
        \   'working_dir': versions#get_root_dir(path)
        \ })
  return map(logs, "{
        \   'word': v:val.revision . ' | ' . v:val.author . ' | ' . v:val.date . ' | ' . v:val.message,
        \   'action__log': v:val,
        \   'kind': 'versions/svn/log',
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

