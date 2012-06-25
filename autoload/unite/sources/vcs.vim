"==========================================================================
" FILE:     vcs.vim
" AUTHOR:   umezo <umezo100+vim@gmail.com>
" Version: 0.1.0
"==========================================================================

let s:save_cpo  = &cpo
set cpo&vim

let s:vcs_commands  = [
\   'status',
\   'diff',
\   'blame',
\   'info',
\   'log'
\]

function! s:define_sources()
    let l:sources   = []
    for l:vcs_command in s:vcs_commands
        let l:source  = {
\           'vcs_command'   : l:vcs_command,
\           'name'          : 'vcs/' . l:vcs_command,
\       }

        function! l:source.gather_candidates(args, context)
            " is it collect ?
            " should id check a:args ?
            let buffer = bufnr( '%' )

            " call VCSCommand function to check vcs type
            let vcsType = VCSCommandGetVCSType( buffer )

            " create object for unite sorce by vcsType and command 
            let l:obj   = unite#libs#vcs#{vcsType}#{self.vcs_command}#new()

            call l:obj.initialize(a:args)
            return map(obj.get_unite_normalized_data(self.name), '{
\               "word"              : v:val.word,
\               "source"            : v:val.source,
\               "kind"              : v:val.kind,
\               "action__path"      : v:val.action__path,
\               "action__line"      : v:val.action__line,
\               "source__candidate" : v:val
\           }')
        endfunction

        call add(l:sources, l:source)
    endfor
    return l:sources
endfunction

function! unite#sources#vcs#define()
    return s:define_sources()
endfunction

"call unite#libs#svn#extension#kind#define()
let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
