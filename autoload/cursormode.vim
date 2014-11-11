let s:last_mode = ''
let s:escape_template = '"%s\033]Pl%s\033\\"'
let s:escape_prefix = exists('$TMUX') ? '\033Ptmux;\033' : ''

function! cursormode#CursorMode()
  let mode = mode()
  if mode !=# s:last_mode
    let s:last_mode = mode
    let color_map = g:cursor_mode#{g:colors_name}#color_map
    if has_key(color_map, mode)
      let color = substitute(color_map[mode], '^#', '', '')
      let escape = printf(s:escape_template, s:escape_prefix, color)
      let command = printf('printf %s > /dev/tty', escape)

      call system(command)
      redraw!
    endif
  endif
  return ''
endfunction

function! cursormode#Activate()
  let &statusline .= has('gui_running') ? '' : '%{cursormode#CursorMode()}'
endfunction
