" Neovim-qt Guifont command, to change the font
" command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>")
" Set font on start
" let g:Guifont="DejaVu Sans Mono for Powerline:h13"
call GuiWindowMaximized(1)
Guifont Consolas:h12
" exe 'Guifont Consolas:h12'
