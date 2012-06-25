"==========================================================================
" FILE:     kind.vim
" AUTHOR:   hrsh7th <hrsh7th+vim@gmail.com>
" Version:  0.1.0
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>
"==========================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:vcs_commit    = {
\   'description'   : 'vcs commit this position',
\   'is_selectable' : 1,
\}
function! s:vcs_commit.func(candidates)
    execute 'VCSCommit ' . join(map(a:candidates, 'v:val.action__path'))
endfunction

let s:vcs_add  = {
\   'description'   : 'vcs add this position',
\   'is_selectable' : 1,
\}
function! s:vcs_add.func(candidates)
    execute 'VCSAdd ' . join(map(a:candidates, 'v:val.action__path'))
endfunction

let s:vcs_revert    = {
\   'description'   : 'vcs revert this position',
\   'is_selectable' : 1,
\}
function! s:vcs_revert.func(candidates)
    execute 'VCSRevert ' . join(map(a:candidates, 'v:val.action__path'))
endfunction

let s:vcs_blame = {
\   'description'   : 'svn blame this position',
\   'is_selectable' : 0,
\}
function! s:vcs_blame.func(candidates)
    execute 'Unite vcs/blame:' . a:candidates.action__path
endfunction

let s:vcs_delete  = {
\   'description'   : 'vcs delete this position',
\   'is_selectable' : 1,
\}
function! s:vcs_delete.func(candidates)
    exec 'VCSDelete ' . join(map(a:candidates, 'v:val.action__path'))
endfunction

let s:vcs_log   = {
\   'description'   : 'vcs log this position',
\   'is_selectable' : 0
\}
function! s:vcs_log.func(candidates)
  call unite#start([['vcs/log', a:candidates.action__path]])
endfunction

let s:vcs_diff   = {
\   'description'   : 'vcs diff all file on this repository',
\   'is_selectable' : 1,
\}
function! s:vcs_diff.func(candidates)
  for candidate in a:candidates
    let revision = exists('candidate.source__candidate.source__revision') ? candidate.source__candidate.source__revision : 'HEAD'
    exec 'tabedit ' . candidate.action__path
    exec 'VCSVimDiff ' . revision
  endfor
endfunction

"let s:vcs_resolved   = {
"\   'description'   : 'vcs resolved this position',
"\   'is_selectable' : 1,
"\}
"function! s:vcs_resolved.func(candidates)
"    execute '! svn resolved '
"\             . join(map(a:candidates, 'v:val.action__path'))
"endfunction

function! unite#libs#vcs#kind#define()

    "{{{ kind
    "{{{ vcs commit
    call unite#custom_action('source/vcs/status/jump_list',
    \                        'commit',
    \                        s:vcs_commit)
    call unite#custom_alias('source/vcs/status/jump_list',
    \                        'ci',
    \                        'commit')
    "}}}
    "{{{ vcs add
    call unite#custom_action('source/vcs/status/jump_list',
    \                        'add',
    \                        s:vcs_add)
    "}}}
    "{{{ vcs revert
    call unite#custom_action('source/vcs/status/jump_list',
    \                        'revert',
    \                        s:vcs_revert)
    "}}}
    "{{{ vcs blame
    call unite#custom_action('source/vcs/status/jump_list',
    \                        'blame',
    \                        s:vcs_blame)
    "}}}
    "{{{ vcs delete
    call unite#custom_action('source/vcs/status/jump_list',
    \                        'delete',
    \                        s:vcs_delete)
    "}}}
    "{{{ vcs log
    call unite#custom_action('source/vcs/status/jump_list',
    \                        'log',
    \                        s:vcs_log)
    "}}}
    "{{{ vcs diff
    call unite#custom_action('source/vcs/status/jump_list,source/vcs/log/jump_list',
    \                        'diff',
    \                        s:vcs_diff)
    call unite#custom_alias('source/vcs/status/jump_list',
    \                        'di',
    \                        'diff')
    "}}}
    "{{{ vcs resolved
    "call unite#custom_action('source/vcs/status/jump_list',
    "\                        'resolved',
    "\                        s:vcs_resolved)
    "}}}
    "}}}

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: foldmethod=marker :

