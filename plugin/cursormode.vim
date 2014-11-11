if exists('g:loaded_cursormode')
  finish
endif
let g:loaded_cursormode = 1

call cursormode#Activate()

augroup cursormode
  autocmd!
  autocmd VimLeave * call cursormode#SetCursorColorFor("n")
augroup END
