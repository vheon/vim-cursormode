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

let s:is_iTerm = exists('$TERM_PROGRAM') && $TERM_PROGRAM =~# 'iTerm.app'
let s:tmux_escape_prefix = empty('$TMUX') ? '' : '\033Ptmux;\033'
let s:iTerm_escape_template = '"%s\033]Pl%s\033\\"'

function! cursormode#CursorMode()
  let mode = mode()
  if mode !=# s:last_mode
    let s:last_mode = mode
    call s:set_cursor_color_for(mode)
  endif
  return ''
endfunction

function! s:set_cursor_color_for(mode)
  let mode = a:mode
  for mode in [a:mode, a:mode.&background]
    if has_key(s:color_map, mode)
      let color = s:iTerm_color(s:color_map[mode])
      let escape = printf(s:iTerm_escape_template, s:tmux_escape_prefix, color)
      let command = printf('printf %s > /dev/tty', escape)

      silent call system(command)
      return
    endif
  endfor
endfunction

function! s:iTerm_color(color)
  return substitute(a:color, '^#', '', '')
endfunction

function! s:get_color_map()
  if exists('g:cursormode_color_map')
    return g:cursormode_color_map
  elseif exists('g:colors_name') && exists('g:cursormode_{g:colors_name}_color_map')
    return g:cursormode_{g:colors_name}_color_map
  else
    return {
          \   "nlight": "#000000",
          \   "ndark":  "#BBBBBB",
          \   "i":      "#0000BB",
          \   "v":      "#FF5555",
          \   "V":      "#BBBB00",
          \   "\<C-V>": "#BB00BB",
          \ }
  endif
endfunction
let s:color_map = s:get_color_map()

function! cursormode#Activate()
  call s:activate('&statusline')
endfunction

function! cursormode#LocalActivate()
  call s:activate('&l:statusline')
endfunction

function! s:activate(on)
  if has('gui_running')
    return
  endif

  call s:deactivate(a:on)
  execute 'let' a:on ".= '%{cursormode#CursorMode()}'"

  call s:setup_autocmds()
endfunction

function! s:deactivate(on)
  execute 'let' a:on "= substitute(".a:on.", '%{cursormode#CursorMode()}', '', 'g')"
endfunction

function! s:setup_autocmds()
  augroup cursormode
    autocmd!
    autocmd VimLeave * call s:set_cursor_color_for("n")
    autocmd Colorscheme * let s:color_map = s:get_color_map()
  augroup END
endfunction
