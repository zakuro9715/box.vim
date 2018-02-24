if exists("g:loaded_box")
  finish
endif
let g:loaded_box = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* Box call box#CmdBox(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
