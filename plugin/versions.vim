if exists('g:loaded_versions')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:loaded_versions = 1

let &cpo = s:save_cpo
unlet s:save_cpo

