# Cursor Mode
Change the color of the cursor based on the mode we're in for terminal vim.
At the moment it is just for iTerm2 but should be trivial to add support for Linux terminals.

Why would I want something like this when [vim-airline][] or [powerline][]/[vim-powerline][] already let you color the statusline based on the mode we are in?
Well specially if we use big screen it is not so easy to see the color of the bottom left corner of the statusline,
so I prefer coloring what I'm looking at that usually is where my cursor is.

# How to use it

Install it as any plugin, using your plugin manager of choice:

[vim-plug][]

`Plug 'vheon/vim-cursormode'`

[Vundle.vim][]

`Plugin 'vheon/vim-cursormode'`

[NeoBundle.vim][]

`NeoBundle 'vheon/vim-cursormode'`

Or using [vim-pathogen][]

Then you have to define a map describing the color you want to use for each mode using this format:


```viml
let cursor_mode#colorscheme_name#color_map = {
      \   "mode":      "#rrggbb",
      ...
      \ }
```

The mode string are the ones returned by `:h mode()`

For example this is a couple of maps that I have in my vimrc:

```viml
let cursor_mode#solarized#color_map = {
      \   "n":      "#839496",
      \   "i":      "#268bd2",
      \   "v":      "#cb4b16",
      \   "V":      "#b58900",
      \   "\<C-V>": "#6c71c4",
      \ }
let cursor_mode#gotham#color_map = {
      \   "n":      "#99d1ce",
      \   "i":      "#edb443",
      \   "v":      "#d26937",
      \   "V":      "#c23127",
      \   "\<C-V>": "#4e5166",
      \ }
```

The colors are in the form of `#rrggbb`.

# Known Issues

* At the moment it works only in iTerm2

# Credits

Idea stolen from [http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/][]
He uses the `guicursor` option which it's for GUI, MSDOW and Win32 console only
but I use terminal vim on iTerm2 only at the moment so I thoght about sending escape codes to
iTerm2 to change the cursor color.

[vim-airline]: https://github.com/bling/vim-airline 
[powerline]: https://github.com/Lokaltog/powerline 
[vim-powerline]: https://github.com/Lokaltog/vim-powerline 
[vim-plug]: https://github.com/junegunn/vim-plug 
[Vundle.vim]: https://github.com/gmarik/Vundle.vim 
[NeoBundle.vim]: https://github.com/Shougo/neobundle.vim 
[vim-pathogen]: https://github.com/tpope/vim-pathogen 
[http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/]: http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/ 
