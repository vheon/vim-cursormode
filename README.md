# Cursor Mode
Change the color of the cursor based on the mode we're in for terminal vim.
At the moment it is just for iTerm2 but should be trivial to add support for Linux terminals.

Why would I want something like this when [vim-airline][] or [powerline][]/[vim-powerline][] already let you color the statusline based on the mode we are in?
Well specially if we use big screen it is not so easy to see the color of the bottom left corner of the statusline,
so I prefer coloring what I'm looking at that usually is where my cursor is.

# How to use it

Install it as any plugin, using your plugin manager of choice:

[vim-plug][]

```viml
Plug 'vheon/vim-cursormode'
```

[Vundle.vim][]

```viml
Plugin 'vheon/vim-cursormode'
```

[NeoBundle.vim][]

```viml
NeoBundle 'vheon/vim-cursormode'
```

Or using [vim-pathogen][]

# Cursor colors
For setting the color to be used in the different mode you have a couple of options:

* define a variable `g:cursormode_color_map`
* define a variable with a name like `g:cursormode#{colorscheme}#color_map` 
i.e. `let cursormode#solarized#color_map = {...}`
This kind of maps are reloaded if you change the colorscheme.
As you may have noticed this are autoload variable, so you could define them in a
`autoload/cursormode/{colorscheme}.vim` file. So for example you could ship this file with a colorscheme.

If none of the above are defined we use a default color map using the colors in the default colorscheme in iTerm2

## Color map format

Every color map is in the form:

```viml
let cursormode_color_map = {
      \   "mode":      "#rrggbb",
      ...
      \ }
```

The mode string are the ones returned by `:h mode()` and the colors are in the form of `#rrggbb`.

For example this is a possible map:

```viml
let cursormode_color_map = {
      \   "n":      "#FFFFFF",
      \   "i":      "#0000FF",
      \   "v":      "#00FF00",
      \   "V":      "#FF0000",
      \   "\<C-V>": "#FFFF00",
      \ }
```

If you want to specify a color for a mode based on the `background` you can do it appending the background string to the mode

For example here is my solarized map with the normal mode color based on the background:

```viml
let cursormode_solarized_color_map = {
      \   "nlight": "#657b83",
      \   "ndark":  "#839496",
      \   "i":      "#268bd2",
      \   "v":      "#cb4b16",
      \   "V":      "#b58900",
      \   "\<C-V>": "#6c71c4",
      \ }
```

# Known Issues

* At the moment it works only in iTerm2
* Sporadically the view is moved, so for example I enter Insert mode and the current line is moved at the top as if I typed `zt`. I didn't find a way of debug this thing, so any input or PR are welcome.

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
