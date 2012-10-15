let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#versions#git#log#define()
  return [s:source]
endfunction

let s:source = {
      \ 'name': 'versions/git/log',
      \ 'description': 'vcs repository log.',
      \ 'hooks': {},
      \ }

function! s:source.hooks.on_init(args, context)
  let a:context.source__args = {}
  let a:context.source__args.path = unite#sources#versions#get_path(
        \ get(a:args, 0, '%'))
  let a:context.source__args.limit = get(a:args, 1, '')
endfunction

function! s:source.gather_candidates(args, context)
  let path = a:context.source__args.path
  let limit = a:context.source__args.limit

  call unite#print_message('[versions/log] type: ' . versions#get_type(path))
  call unite#print_message('[versions/log] path: ' . path)

  let logs = versions#command('log', {
        \   'path': path,
        \   'limit': limit
        \ }, {
        \   'working_dir': path
        \ })
  return map(logs, "{
        \   'word': v:val.revision . ' | ' . v:val.author . ' | ' . v:val.date . ' | ' . v:val.message,
        \   'action__log': v:val,
        \   'source__args': a:context.source__args,
        \   'kind': 'versions/git/log',
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

