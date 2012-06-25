"==========================================================================
" FILE:     log.vim
" AUTHOR:   umezo <umezo100+vim@gmail.com>
" Version: 0.1.0
"==========================================================================

let s:save_cpo  = &cpo
set cpo&vim

function! s:str2list(str)
    return split(a:str, '\n')
endfunction

function! s:get_log_commits( path )
  let log_output = split( system('git log '.a:path) , 'commit ' )
  " git commit log has three lines normally , commit , authtor and date
  return filter( map( log_output , 'split( v:val , "\n" )' ) , "len(v:val)>=3" )
endfunction

function! s:get_lines(path)
  echomsg join( s:get_log_commits( a:path ) , "======" )
  " make line REV Author Date CommitMessage 
  return map( s:get_log_commits( a:path ) , 'v:val[0]." | ".split(v:val[1],"Author: ")[0]." | ".split(v:val[2],"Date:   ")[0]." | ".v:val[4]' )
endfunction

function! s:get_data_list(path)
    return map( s:get_lines(a:path) , 'split(v:val,"|")' )
endfunction


function! unite#libs#vcs#git#log#new()
    let l:obj   = {}

    function l:obj.initialize(args)
        if 0 == len(a:args)
            let self.target    = expand('%')
        else
            let self.target    = a:args[0]
        endif
        let self.data_list  = s:get_data_list(self.target)
    endfunction

    function l:obj.get_unite_normalized_data(source)
        return map(
\           self.data_list, '{
\               "word"          : join(v:val,"|") ,
\               "source"        : a:source,
\               "kind"          : "jump_list",
\               "action__path"  : self.target,
\               "action__line"  : 1,
\               "source__revision" : v:val[0] ,
\           }'
\       )
    endfunction

    return l:obj
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

