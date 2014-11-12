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
    call s:set_cursor_color_for(mode)
  endif
  return ''
endfunction

function! s:set_cursor_color_for(mode)
  let color_map = s:get_color_map()
  let mode = a:mode
  for mode in [a:mode, a:mode.&background]
    if has_key(color_map, mode)
      let color = substitute(color_map[mode], '^#', '', '')
      let escape = printf(s:escape_template, s:escape_prefix, color)
      let command = printf('printf %s > /dev/tty', escape)

      silent call system(command)
      break
    endif
  endfor
endfunction

function! s:get_color_map()
  " XXX: this map should be calculated upfront
  "      * Set an autocmd for Colorscheme so we can detect if a
  "            g:cursormode_{colorscheme}_color_map is available
  "      * Make a note about creating map on the fly. If we set up the map in
  "            the Activate function then since is idenpotent would be possible
  "            to reload it by calling the function again
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

function! cursormode#Activate()
  call s:activate('&statusline')
endfunction

function! cursormode#LocalActivate()
  call s:activate('&l:statusline')
endfunction

function! s:activate(on)
    return
  endif
  if has('gui_running')
    return
  endif

  call s:deactivate(a:on)
  execute 'let' a:on ".= '%{cursormode#CursorMode()}'"

  call s:setup_restore_on_vim_leave()
endfunction

function! s:deactivate(on)
  execute 'let' a:on "= substitute(".a:on.", '%{cursormode#CursorMode()}', '', 'g')"
endfunction

function! s:setup_restore_on_vim_leave()
  augroup cursormode
    autocmd!
    autocmd VimLeave * call s:set_cursor_color_for("n")
  augroup END
endfunction
