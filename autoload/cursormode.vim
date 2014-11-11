" Copyright (C) 2014 Andrea Cedraro <a.cedraro@gmail.com>
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the "Software"),
" to deal in the Software without restriction, including without limitation
" the rights to use, copy, modify, merge, publish, distribute, sublicense,
" and/or sell copies of the Software, and to permit persons to whom the
" Software is furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included
" in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
" OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
" DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
" TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
" OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

let s:last_mode = ''
let s:escape_template = '"%s\033]Pl%s\033\\"'
let s:escape_prefix = exists('$TMUX') ? '\033Ptmux;\033' : ''

function! cursormode#CursorMode()
  let mode = mode()
  if mode !=# s:last_mode
    let s:last_mode = mode
    call s:setCursorColorFor(mode)
  endif
  return ''
endfunction

function! s:setCursorColorFor(mode)
    let color_map = g:cursor_mode#{g:colors_name}#color_map
    if has_key(color_map, a:mode)
      let color = substitute(color_map[a:mode], '^#', '', '')
      let escape = printf(s:escape_template, s:escape_prefix, color)
      let command = printf('printf %s > /dev/tty', escape)

      silent call system(command)
    endif
endfunction

function! cursormode#Activate()
  call s:activate('&statusline')
endfunction

function! cursormode#LocalActivate()
  call s:activate('&l:statusline')
endfunction

function! s:activate(on)
  call s:deactivate(a:on)
  execute 'let' a:on ".= has('gui_running') ? '' : '%{cursormode#CursorMode()}'"

  call s:setup_restore_on_vim_leave()
endfunction

function! s:deactivate(on)
  execute 'let' a:on "= substitute(&statusline, '%{cursormode#CursorMode()}', '', 'g')"
endfunction

function! s:setup_restore_on_vim_leave()
  augroup cursormode
    autocmd!
    autocmd VimLeave * call s:setCursorColorFor("n")
  augroup END
endfunction
