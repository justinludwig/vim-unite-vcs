let s:save_cpo = &cpo
set cpo&vim

" HASH, PREV_HASH, AUTHOR_NAME, AUTHOR_EMAIL, AUTHOR_DATE, SUBJECT
let g:vcs#git#log_format = '%H%x09%P%x09%an%x09%ae%x09%ai%x09%s'

let &cpo = s:save_cpo
unlet s:save_cpo

