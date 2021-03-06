" vim: set sw=2 ts=4 sts=2 et tw=80 foldlevel=0 foldmethod=marker:
" ==========================================================
" PROSTOR _vimrc | based on vimtest3 | last edit: 2017-05-10 Ср 06:05 
" ==========================================================

" Be Improved, encoding, mapleader, OS detect, rtp and clipboard {{{
" romainl says it's useless:
" set nocompatible
" ========================================
" set encoding=utf-8
" " Список кодировок для автоматического определения, в порядке предпочтения
" " взято с http://jenyay.net/Programming/Vim
" set fileencodings=utf-8,cp1251,utf-16le,cp866,koi8r,ucs-2le
" set fileencoding=utf-8    " set save encoding
" ========================================
" if &termencoding == ""
"   let &termencoding = &encoding
" else
"   set termencoding=utf-8  " set terminal encoding
" endif
" ========================================
"explanation: http://stackoverflow.com/a/5795441/453396
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8                      "better default than latin1
    setglobal fileencoding=utf-8            "change default file encoding when writing new files
endif
" ========================================
let mapleader    = "\<space>"
let g:mapleader  = "\<space>"
" ========================================
let s:is_windows = has('win32') || has('win64')
let s:is_wingui  = has("gui_win32")
let s:is_cygwin  = has('win32unix')
let s:is_macvim  = has('gui_macvim')
let s:is_nvim    = has('nvim')
let s:is_nyaovim = exists('g:nyaovim_version')
let s:is_gui     = has('gui_running')
let s:is_conemu  = !empty($CONEMUBUILD)
" ========================================
" portability shim:
let $DOTVIMDIR = expand('$HOME/dotfiles')
if !isdirectory(expand('$DOTVIMDIR'))
  let $DOTVIMDIR = expand('$VIM/vimfiles')
  echom "** ! **: dotfiles dir don't exist"
endif
set rtp^=$DOTVIMDIR
" ========================================
let s:plugs = "plugged"
let s:plugdir = $DOTVIMDIR.'\'.s:plugs
set backupdir=$DOTVIMDIR/backups
set directory=$DOTVIMDIR/swap
set undodir=$DOTVIMDIR/undo
set viminfo+=n$DOTVIMDIR/swap/viminfo
" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif
" ========================================
if has('clipboard')
  if has('unnamedplus')         " When possible use + register for copy-paste
    set clipboard=unnamed,unnamedplus
  else                          " On mac and Windows, use * register for copy-paste
    set clipboard=unnamed
  endif
endif
set timeout timeoutlen=230
" }}}

" Plugin Install {{{1
" let g:plug_threads = 2
call plug#begin(s:plugdir)
" == Necessity == {{{2
Plug 'editorconfig/editorconfig-vim'
" Emmet {{{3
let emmetlist = ['html','smarty','pug','php','xml','xsl','xslt','xsd','css','sass','scss','less','styl','stylus','mustache','handlebars']
Plug 'mattn/emmet-vim', {'for': emmetlist }
  let g:user_emmet_settings = {
        \ 'php': {
        \     'snippets': {
        \         'php': "<?php |; ?>",
        \         'tf':  "<?php the_field('|', 'options'); ?>",
        \         'tsf': "<?php the_sub_field('|'); ?>",
        \         'if':  "<?php if(|${child}): ?>",
        \         'hr':  "<?php if( have_rows('${cursor}', 'option') ): ?>\n\t<?php while( have_rows('${cursor}', 'option')): the_row(); ?>\n\t${2}\n\t<?php endwhile; ?>\n<?php endif; ?>",
        \         'els': "<?php elseif(|): ?>",
        \         'wh':  "<?php while(|${child}): ?>",
        \         'ei':  "<?php endif; ?>",
        \         'ew':  "<?php endwhile; ?>",
        \         },
        \     },
        \ }
  let g:user_emmet_leader_key = '\'
  " autocmd FileType stylus,html,css,less,sass,scss imap <buffer><expr><C-Space> <sid>cw#zen_html_tab()
  autocmd FileType {ht,x,xs}ml,php,pug,s\\\{-\}[ac]ss,less,stylus imap <buffer><expr> <C-Space> emmet#expandAbbrIntelligent("\<C-Space>")
  " autocmd FileType stylus,html,css,less,sass,scss imap <buffer><expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
"}}}3
Plug 'nathanaelkane/vim-indent-guides' "{{{3
  " <leader>ig
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 1
  let g:indent_guides_color_change_percent=3
  if !has('gui_running')
    let g:indent_guides_auto_colors=0
    function! s:indent_set_console_colors()
      hi IndentGuidesOdd ctermbg=235
      hi IndentGuidesEven ctermbg=236
    endfunction
    autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
  endif
" }}}3
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] } "{{{3
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  xmap <Enter> <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap <Leader>a <Plug>(EasyAlign)
" }}}3
Plug 'ctrlpvim/ctrlp.vim' "{{{3
  nnoremap <leader>b :CtrlPBuffer<cr>
  nnoremap <Leader>o :CtrlPMRUFiles<CR>
  let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
Plug 'zhaocai/GoldenView.Vim', {'on' : '<Plug>ToggleGoldenViewAutoResize'} "{{{3
  let g:goldenview__enable_default_mapping=0
  nmap <F5> <Plug>ToggleGoldenViewAutoResize
  " }}}3
Plug 'mhinz/vim-startify' "{{{3
 nnoremap <F1> :Startify<CR>
 let g:startify_list_order = ['files', 'sessions', 'bookmarks']
 let g:startify_bookmarks = [{'p': 'D:\Dropbox\TODO\PROSTOR.todo'}, {'r': '~\_vimrc'}]
 let g:startify_update_oldfiles = 1
 let g:startify_session_autoload = 1
 let g:startify_session_persistence = 1
 let g:startify_session_delete_buffers = 1
 "}}}3
Plug 'rking/ag.vim', {'on' :'Ag'} " {{{3
" if executable('ag')
"   Plug 'mileszs/ack.vim', {'on' :'Ack'}
"   let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
" elseif executable('ack-grep')
"   let g:ackprg="ack-grep -H --nocolor --nogroup --column"
"   Plug 'mileszs/ack.vim', {'on' :'Ack'}
" elseif executable('ack')
"   Plug 'mileszs/ack.vim', {'on' :'Ack'}
" endif
" }}}3
" * * * * *
" -- open url in browser -- {{{3
Plug 'kana/vim-textobj-user'
Plug 'jceb/vim-textobj-uri'
Plug 'tyru/open-browser.vim'
" }}}3
" -- parenthesis -- {{{3
" Plug 'Raimondi/delimitMate'
"   let delimitMate_expand_cr = 1
" Plug 'jiangmiao/auto-pairs' " overrides cyrilic letters on [ and ]
Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'luochen1990/rainbow'
"   let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
Plug 'matchit.zip'
  let b:match_ignorecase = 1
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
"}}}3
" -- hotkeys {{{3
Plug 'tpope/vim-rsi'
Plug 'romainl/vim-qf'
Plug 'tpope/vim-unimpaired'
" -- repeat {{{3
Plug 'tpope/vim-repeat'
" Plug 'kana/vim-repeat'
" -- comment {{{3
" Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-commentary'
" Plug 'tyru/caw.vim'
"   let g:caw_operator_keymappings = 1
" }}}3
" -- text objects -- {{{3
" Plug 'kana/vim-textobj-user' " <- dependency
" Plug 'kana/vim-textobj-fold'
" Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-indent'
Plug 'jasonlong/vim-textobj-css', {'for': ['css', 'scss', 'less']}
" }}}3
" -- gist-vim {{{3
Plug 'mattn/gist-vim' | Plug 'mattn/webapi-vim'
" }}}3
" -- utils -- {{{3
Plug 'justinmk/vim-dirvish' "doesn't work with autochdir
Plug 'skywind3000/asyncrun.vim', {'on':['Gulp','GulpExt']}
Plug 'mbbill/fencview', {'on' : 'FencAutoDetect'}
Plug 'tpope/vim-fugitive'
Plug 'justinmk/vim-sneak'
  let g:sneak#streak=1
Plug 'konfekt/fastfold'
  let g:fastfold_savehook = 1
" ST's PlainTasks compatible!
Plug 'irrationalistic/vim-tasks'
" == < webdev \> == {{{2
" General
Plug 'othree/html5.vim',       {'for': ['html', 'php', 'tpl']}
Plug 'JulesWang/css.vim',      {'for': ['css', 'html', 'scss', 'sass', 'less']}
Plug 'hail2u/vim-css3-syntax', {'for': ['css','html','scss','sass','less']}
Plug 'closetag.vim',           {'for': ['html', 'php', 'tpl']}
" ---------------
" Pre HTML
Plug 'digitaltoad/vim-pug', {'for': ['jade','pug']}
Plug 'tpope/vim-markdown', {'for': ['markdown', 'md', 'mdown', 'mkd', 'mkdn']}
" ---------------
" Pre CSS
Plug 'cakebaker/scss-syntax.vim', {'for': ['sass', 'scss']}
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'wavded/vim-stylus', {'for':['styl','stylus']}
" ---------------
" Post CSS
Plug 'csscomb/vim-csscomb', {'on': 'CSScomb'}
" ---------------
" Js
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'js', 'html'] }
Plug 'elzr/vim-json', { 'for': ['json', 'javascript', 'js', 'html'] }
  let g:vim_json_syntax_conceal = 0
" ---------------
Plug 'KabbAmine/gulp-vim', {'on': ['Gulp','GulpExt']}
Plug 'gorodinskiy/vim-coloresque', {'for': ['html', 'css', 'less', 'sass', 'stylus', 'php']} " *^* This
" Plug 'ap/vim-css-color', {'for': ['html', 'css', 'less', 'php']} " Trying *^* instead of this colorizer

" == Colorschemes == {{{2
" -- utilitiy -- {{{3
Plug 'vim-scripts/ScrollColors', { 'on': 'SCROLLCOLOR' }
" Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" -- * * * --- {{{3
Plug 'ajh17/Spacegray.vim'
" Plug 'kristijanhusak/vim-hybrid-material'
" let g:airline_theme = "hybrid"
" Plug 'jasonlong/lavalamp'
Plug 'amadeus/vim-evokai'
" Plug 'jacoborus/tender'
" Plug 'junegunn/seoul256.vim'
" -- * * * * -- {{{3
" Plug 'KabbAmine/yowish.vim'
" Plug 'dracula/vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'chriskempson/base16-vim'
Plug 'chriskempson/vim-tomorrow-theme'
" -- * * * * * -- {{{3
Plug 'nanotech/jellybeans.vim'
Plug 'sjl/badwolf'
Plug 'tomasr/molokai'
" Plug 'zeis/vim-kolor'
"   let g:kolor_underlined=1
" -- newest themes -- {{{3
"}}}3
" -- theme assignment --
" let s:cs_wingui='base16-mocha'
let s:cs_wingui='spacegray'
let s:cs_xterm='jellybeans'
let s:cs_nvim='molokai'
let s:cs_cmder='badwolf'
" == new stuff == {{{2
" 2017-05-18 {{{3
Plug 'prabirshrestha/asyncomplete.vim'
" 2017-05-17 {{{3
Plug 'ervandew/supertab'
" 2017-04-26 {{{3
" I'm not sure what it is doing
Plug 'dsawardekar/wordpress.vim'
" 2017-04-20 {{{3
Plug 'osyo-manga/vim-anzu'
" 2017-04-17 {{{3
Plug 'stephenway/postcss.vim'
" 2017-04-14 {{{3
Plug 'alvan/vim-closetag'
Plug 'rstacruz/vim-closer'
Plug 'rstacruz/vim-hyperstyle' "requires python27
" 2017-03-31 {{{3
Plug 'junegunn/fzf', { 'dir': '~/.fzf'} | Plug 'junegunn/fzf.vim'
nmap <leader><tab> <plug>(fzf-maps-n)
imap <c-x><c-k> <plug>(fzf-complete-word)
" 2017-03-21 {{{3
Plug 'takac/vim-hardtime'
nnoremap <leader><F1> <Esc>:HardTimeToggle<CR>
let g:hardtime_ignore_quickfix = 1
" 2017-03-13 {{{3
" Track the engine.
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" Snippets are separated from the engine. Add this if you want them: Plug 'honza/vim-snippets'
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" 2017-03-09 {{{3
Plug 'moll/vim-node', {'for': [ 'js', 'javascript' ]}
Plug 'sickill/vim-monokai'
" 2017-02-22 {{{3
Plug 'fcpg/vim-showmap'
" 2017-02-06 {{{3
Plug 'w0rp/ale'
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_statusline_format = [' ✖ %d ', ' ! %d ', '']
Plug 'ternjs/tern_for_vim', {'for': [ 'js', 'javascript' ]}
let g:tern_map_keys = 1
Plug 'itspriddle/vim-jquery', {'for': [ 'js', 'javascript' ]}
" }}}3
" == old == {{{2
Plug 'vim-scripts/DrawIt', {'on': 'DrawIt'}
" Plug 'wellle/targets.vim'
" Plug 'kana/vim-operator-user'

call plug#end() " required }}}1

" General {{{

scriptencoding utf-8
set iskeyword=@,a-z,A-Z,48-57,_,128-175,192-255
set keymap=russian-jcukenwin
set iminsert=0              " раскладка по умолчанию для ввода - английская
set imsearch=0              " раскладка по умолчанию для поиска - английская
set mouse=a
set autoread
set hidden                  " Allow buffer switching without saving
set nobackup                " Отключить создание файлов бекапа
set nowritebackup
set noswapfile              " и свапа
set history=1000
set sessionoptions-=options " do not store global and local values in a session
set path+=**                " doesn't work well in Windows
set synmaxcol=800           " Don't try to highlight lines longer than 800 chars

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone
set formatoptions=qrn1j
" }}}

" Formatting {{{

  set nowrap
  set textwidth=0                " Don't automatically insert linebreaks
  " set formatoptions-=t           " don't automatically wrap text when typing
  " set formatoptions+=j           " Delete comment character when joining commented lines
  set formatoptions+=M
  set autoindent
  set shiftround
  set linebreak
  " let &showbreak='↪ '
  let &showbreak='▷ '
  set breakindent
  set tabstop=4                  " размер табов
  set softtabstop=4
  set shiftwidth=4               " размер отступов
  set smarttab
  set noexpandtab
  set nojoinspaces               " Prevents inserting two spaces after punctuation on a join (J)
  set backspace=indent,eol,start " Backspace for dummies

" }}}

" Statusline {{{
" Powerline symbols quick ref:
"  > Triangle U+e0b0,  > U+e0b1,  < Triangle U+e0b2,
"  < U+e0b3,  Git U+e0a0,  LN U+e0a1,  Lock U+e0a2
set statusline=
set statusline+=\ %n
set statusline+=\ \ %<%F\ %{cw#ReadOnly()}
set statusline+=\ %=                                " Space
set statusline+=\ \"%{v:register}
set statusline+=\ \ %8*%k%m%r%w
set statusline+=%0*%y%{(&fenc!=?'utf-8'?'['.&fenc.']':'')}
set statusline+=%{&ff!=?'unix'?'['.&ff.']':''}      " Encoding & Fileformat
set statusline+=\ \\ %-3(%{cw#FileSize()}%)        " File size
set statusline+=%8*%3c:%3l/%L
set statusline+=\ %*
" ========================================
"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{anzu#search_status()}
set statusline+=%{ALEGetStatusLine()}
set statusline+=%{cw#StatuslineTabWarning()}
set statusline+=%{cw#StatuslineTrailingSpaceWarning()}
set statusline+=%*
" }}}

" UI {{{1

set laststatus=2
set colorcolumn=+1
set cmdheight=2
set noeb
set lazyredraw
set scrolloff=3                                " Minimum lines to keep above and below cursor
set scrolljump=5                               " Lines to scroll when cursor leaves screen
set shortmess=amroOtT                          " a doesn't add m and r despite what docs says
set cursorline
set number                                     " Line numbers on
set relativenumber
set showmatch                                  " Show matching brackets/parenthesis
set matchtime=2                                " tens of a second to show matching parentheses
set incsearch                                  " Find as you type search
set nohlsearch                                 " Highlight search terms; it's annoying and distracting, turning it off - 2016-12-15:
set winminheight=0                             " Windows can be 0 line high
set ignorecase                                 " Case insensitive search
set smartcase                                  " Case sensitive when uc present
set wildmenu                                   " Show list instead of just completing
set wildmode=list:longest,full                 " Command <Tab> completion, list matches, then longest common part, then all.
set foldenable                                 " Auto fold code
set list
set listchars=tab:│\ ,eol:¬,trail:•,extends:#,nbsp:⋅ " Highlight problematic whitespace

" set listchars=tab:›\ ,trail:•,extends:#,nbsp:⋅ " Highlight problematic whitespace
" set listchars=tab:▷⋅,trail:⋅,nbsp:⋅            " Alternative settings

set splitright                                 " Puts new vsplit windows to the right of the current
set splitbelow                                 " Puts new split windows to the bottom of the current

let g:netrw_altv=1                             " open splits to the right
let g:netrw_banner=0
let g:netrw_browse_split = 4
" liststyle=3 has problems
" let g:netrw_liststyle=2
let g:netrw_silent = 1
let g:netrw_winsize = 25

" set shortmess+=filmnrxoOtT                     " Abbrev. of messages (avoids 'hit enter')
" set foldopen=all                               " Автооткрытие сверток при заходе в них
" set whichwrap=b,s,h,l,<,>,[,]                  " Backspace and cursor keys wrap too
" execute " set colorcolumn=".join(range(80,335), ',')|   "Discolor every column past column 80

" switched off because they're handled by vim-plug {{{2
" moved syntax here to be enabled as late as possible
" due to failed highlighting in number of files
" filetype plugin indent on " Automatically detect file types.
" syntax on                 " must be before colorscheme!
" }}}2
" /UI }}}1

" GUI & Terminal settings {{{1
if s:is_gui
  if s:is_macvim
    set guifont=Consolas:h15
  " Win GUI settings {{{2
  elseif s:is_wingui
    " set guifont=DejaVu_Sans_Mono_for_Powerline:h10:cRUSSIAN
    set guifont=Iosevka_Term:h11:cRUSSIAN:qDRAFT
    let g:airline_powerline_fonts = 1
    " Меню выбора кодировки текста (utf8, cp1251, koi8-r, cp866)
    menu Кодировка.utf-8 :e ++enc=utf8<CR>
    menu Кодировка.windows-1251 :e ++enc=cp1251<CR>
    menu Кодировка.utf-16le :e ++enc=utf-16le<CR>
    menu Кодировка.cp866 :e ++enc=cp866<CR>
    menu Кодировка.koi8-r :e ++enc=koi8-r<CR>
    execute 'colorscheme '.s:cs_wingui
  endif " }}}2
  " echom "^General GUI block^" {{{2
  " currently is go=gmtch
  if s:is_conemu
    set guioptions+=h
    set guioptions-=b
    set guioptions-=r
    set guioptions-=R
    set guioptions-=m
  endif
  set guioptions+=c       " Use console dialogs
  set guioptions-=e       " Disable fancy tabline (repositions vim on tab in Win32)
  set guioptions-=L       " Disable left scrollbar (repositions vim on vsplit in Win32)
  set guioptions-=T       " No toolbar
  set noshowmode
  set ballooneval
  autocmd GUIEnter * set vb t_vb= lines=40 columns=103 linespace=0
  " }}}2
else
  set vb t_vb=
  set ttimeout ttimeoutlen=50
  " neovim {{{2
  if s:is_nvim
    let s:editor_root=expand("~/AppData/Local/nvim")
    " let g:python_host_prog = '/usr/bin/python'
    " let g:python3_host_prog = '/usr/bin/python3'
    if exists('g:GuiFont')
      " WTF?! Doesn't work?
      " let g:Guifont="DejaVu Sans Mono for Powerline:h13"

      " Works and even looks nice, however reports bad fixed pitch metrics
      " Also it's risky to install patched version on Windows
      " GuiFont Consolas:h12

      " Warning: bad fixed pitch metrics?!
      " GuiFont Anonymice Powerline:h12

      "is not fixed pitch font?!
      " GuiFont Arimo for Powerline:h12
      " GuiFont DejaVu Sans Mono for Powerline:h13
      " GuiFont Literation Mono Powerline:h12
      " GuiFont Roboto Mono for Powerline:h13
      " GuiFont Tinos for Powerline:h12

      " Sluggish unaliased look
      " GuiFont Droid Sans Mono for Powerline:h12
      " GuiFont Fira Mono Medium for Powerline:h12

      " A little better look than Droid Sans and Fira
      " GuiFont monofur for Powerline:h14

      " Unknown font
      " GuiFont Ubuntu Mono derivative Powerline:h12
    endif
    execute 'colorscheme '.s:cs_nvim
  endif " }}}2

  " ConEmu terminal settings {{{2
  if s:is_conemu
    " it's already set above
    " set vb t_vb=
    set term=xterm
    set termencoding=utf8
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    execute 'colorscheme '.s:cs_cmder
  endif
  " }}}2
  " Disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  if &term =~ '256color'
    set t_ut=
  endif
endif

"}}}

" Highlighting {{{
hi User8 ctermfg=235 guifg=#483D8B guibg=#A2A3A3

" Only for Dracula colorscheme: {{{
if exists('g:colors_name') && g:colors_name ==# 'dracula'
" hi! link FoldColumn User8
  hi FoldColumn term=standout ctermfg=61 ctermbg=235 guifg=#6272a4 guibg=#282a36 gui=None
endif
" }}}
" }}}

" Autocommands {{{
if has("autocmd")
" Save on losing focus
" Only available for GUI
" autocmd FocusLost * :wa
" Leave Insert Mode on win switch
" autocmd FocusLost,TabLeave * call feedkeys("\<C-\>\<C-n>") | :wa

" --- php ---
function! SetClosetagPHP()
  if exists('g:closetag_filenames')
      let g:closetag_filenames.= ",*.php,*.tpl"
  endif
endfunction
augroup PHP_stuff
  autocmd!
  autocmd FileType php,smarty,tpl call SetClosetagPHP()
  autocmd FileType smarty,tpl setlocal commentstring=<!--\ %s\ -->
augroup END

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

" Relative numbers in the active window {{{
augroup active_relative_number
    autocmd!
    autocmd WinEnter * :setlocal number relativenumber
    autocmd WinLeave * :setlocal norelativenumber
augroup END
" }}}
" Autosource for _vimrc {{{
augroup reload_vimrc
    autocmd!
    autocmd bufwritepost _vimrc,init.vim,vimrc nested source $MYVIMRC
    " Alternative, not working very well, so disabled:
    " autocmd BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC
    " autocmd bufwritepost $HOME/_vimrc execute "normal! :source ~/_vimrc"
augroup END " }}}
augroup Python_skeleton "{{{
  autocmd!
  autocmd BufNewFile *.py[w]\\\{-\} call cw#SkeletonPY()
augroup END "}}}
endif " has("autocmd")
" }}}

" Commands {{{1
" >>> Shell command @ spf-13 {{{2
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" >>> Conversion between TABS ans SPACES {{{2
command! Respace :setlocal expandtab | %retab!
command! Retab :setlocal noexpandtab | %retab!
" https://vi.stackexchange.com/questions/2105/how-to-reverse-the-order-of-lines/2107#2107
command! -bar -range=% Reverse <line1>,<line2>global/^/m<line1>-1|nohl
" }}}1

" Mappings {{{1
" +----------------------------------------------------------+
" | Legend:                                                  |
" | ======                                                   |
" | I  - new things and experiments                          |
" | II - old approved maps that probably never change        |
" | III- commented maps that maybe, will be useful some day  |
" +----------------------------------------------------------+
  "========================================
  " I -- new things and experiments -- {{{2
  "========================================
    " Indent tag
    au FileType html,jinja,htmldjango nnoremap <buffer> <localleader>= Vat=
    " Keep search matches in the middle of the window.
    nnoremap n nzzzv
    nnoremap N Nzzzv

    " Same when jumping around
    nnoremap g; g;zz
    nnoremap g, g,zz
    nnoremap <c-o> <c-o>zz

    " Unfuck my screen
    nnoremap <leader>R :syntax sync fromstart<cr>:redraw!<cr>
    " Comfy warm fluffy and lampy parenthesis jumping
    nnoremap á %
    vnoremap á %

    noremap H ^
    noremap L g_
    nnoremap gl L
    nnoremap gh H

    " Join an entire paragraph.
    " Useful for writing GitHub comments in actual Markdown
    " and then translating it to their bastardized version of Markdown.
    nnoremap <leader>J mzvipJ`z
    " Select (charwise) the contents of the current line, excluding indentation.
    " Great for pasting Python lines into REPLs.
    nnoremap vv ^vg_
    " Substitute
    nnoremap <c-s> :s/
    nnoremap <M-s> :%s/
    vnoremap <c-s> :s/
    " Keep cursor line in place when joining lines
    nnoremap J mzJ`z
    " echo highligting groups
    nnoremap <F7> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
                            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
                            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

    " vimgrep last search
    nnoremap <silent> <leader><F3> :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
    " Browse current dir
    nnoremap <silent> <F11> :silent edit <C-R>=empty(expand('%')) ? '.' : fnameescape(expand('%:p:h'))<CR><CR>
    " from http://twily.info/.vimrc#view {{{3
    " Open vimgrep and put the cursor in the right position
    map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
    " Vimgreps in the current file
    map <leader>/ :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>
    " Close the current buffer
    map <leader>bd :Bclose<cr>

    " Close all the buffers
    map <leader>ba :1,1000 bd!<cr>

    " Switch CWD to the directory of the open buffer
    map <leader>cd :cd %:p:h<cr>:pwd<cr>
    "}}}3
    nnoremap <S-F12> K
    nnoremap K m`a<CR><ESC>``
    " Meta keys test {{{3
    " works in terminal:
    map <M-F5> :echo 'whoa f5'<cr>
    " doesn't work in terminal:
    " Split resize
    map <M-.> 4<C-W><
    map <M-,> 4<C-W>>
    " ==============================
    map <silent> <M-1> :echo 'whoa1'<cr>
    map <M-`> :echo 'cool!'<cr>
    map <M-space> :echo 'lol i can map it'<cr>
    nnoremap <C-@> :echo 'heyheyhey'<cr>
    map <C-k5> :echo 'yup:c5'<cr>

    map <M-=> <C-w>+
    map <M--> <C-w>-
    " =============== }}}3
    nnoremap [<CR> m`i<CR><ESC>``
    nnoremap ]<CR> m`a<CR><ESC>``
    " from Konfekt's leader key post
    " not as useful as emacs binding as it appears
    " nnoremap : ,
    " nnoremap , :
    " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
    " so that you can undo CTRL-U after inserting a line break.
    " Revert with ":iunmap <C-U>".
    inoremap <C-U> <C-G>u<C-U>
  " }}}2 /experiments
  "=================================
  "  II  -- Proven in battle -- {{{2
  "=================================
    " General UI maps
    nnoremap <leader>w :up<cr>
    nnoremap <leader><BS> :set list! list?<cr>

    " [sensible.vim] Use <C-L> to clear the highlighting of :set hlsearch.
    if maparg('<BACKSPACE>', 'n') ==# ''
        nnoremap <silent> <BACKSPACE> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><BACKSPACE>
    endif

    nnoremap <silent> <leader>r :call cw#Cycle_numbering()<CR>
    nnoremap <leader><F11> :so $MYVIMRC<CR> :echo "* .vimrc loaded *"<CR>
    nnoremap <Leader><F12> :tabnew $MYVIMRC<CR>
    " Display all lines with keyword under cursor and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
    " fast copy-paste to the system cb | do i really need it? #2016-07-21
    " vnoremap <Leader>y "+y
    " vnoremap <Leader>p "+p

    " <F#> keys:
    nnoremap <F2> :Vex<CR>
    nnoremap <F4> :set hlsearch! hlsearch?<cr>
    " Word-wrap toggle
    nnoremap <F6> :setl wrap!<bar>:set wrap?<CR>
    imap <F6> <C-O><F6>
    " toggle paste
    noremap <F12> :setl invpaste<CR><bar>:set paste?<CR>

    " URL opening :\
    " https://sts10.github.io/blog/2016/02/16/one-solution-to-a-problem-with-vims-gx-command/
    nnoremap <silent> gx :normal viugx<CR>
    nmap gk <Plug>(openbrowser-smart-search)
    vmap gk <Plug>(openbrowser-smart-search)


    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " Sneaky new line
    nnoremap <silent> <M-j> m`o<ESC>``
    nnoremap <silent> <M-k> m`O<ESC>``
    " Handy line split: before and after cursor
    " fallback maps if Alt won't work
    nnoremap <silent> <leader>j m`o<ESC>``
    nnoremap <silent> <leader>k m`O<ESC>``
    nnoremap <silent> <C-CR> o<ESC>
    nnoremap <silent> <S-CR> O<ESC>
    inoremap <silent> <S-CR> <ESC>O

    " Insert date on <F3> and <S-F3> {{{3
    nnoremap <F8> i<C-R>=strftime("%Y-%m-%d")<CR><Esc>
    inoremap <F8> <C-R>=strftime("%Y-%m-%d")<CR>
    vnoremap <F8> da<C-R>=strftime("%Y-%m-%d")<CR><Esc>
    nnoremap <S-F8> i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
    inoremap <S-F8> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>
    vnoremap <S-F8> da<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
    " }}}3

    " window killer
    nnoremap <silent> Q :call cw#CloseWindowOrKillBuffer()<cr>
    " buffer killer
    " open next and kill previous
    nnoremap <leader>Q :bn<bar>sp<bar>bp<bar>bd<cr>
    " open previous and kill next
    " nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<cr>
    " and shorter alternative (requires at least 2 buffers)
    " nnoremap <leader>Q :b#<bar>bd#<cr>

    " shortcuts for windows {{{3
    nnoremap <leader>= <C-w>=
    nnoremap <leader>v <C-w>v<C-w>l
    nnoremap <leader>s <C-w>s
    nnoremap <leader>vsa :vert sba<cr>
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l
    nnoremap <leader><leader> <C-^>
    "}}}3

    " shortcuts for tabs
    map <leader>tn :tabnew<CR>
    map <leader>tc :tabclose<CR>
    nnoremap <up> :tabnext<CR>
    nnoremap <down> :tabprev<CR>

    " quick buffer open
    nnoremap gb :ls<CR>:b<space>

    " formatting shortcuts
    nmap <leader>f; :call cw#Preserve("%s/;\$//g")<CR>
    nmap <leader>f= :call cw#Preserve("normal gg=G")<CR>
    nmap <leader>f4 :call cw#Preserve("%s/\\s\\+$//e")<CR>
    nmap <expr> <leader>f5 ':%s/' . @/ . '//g<LEFT><LEFT>'
    nmap <expr> <leader>f3 ':%s///g<LEFT><LEFT><LEFT>'
    nmap <expr> <F3> ':g//#<LEFT><LEFT>'
    vmap <leader>s :sort<cr>
    " Easier formatting
    nnoremap <silent> <leader>fq :call cw#Preserve("normal gwip")<CR>

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " screen line scroll - very useful with wrap on
    nnoremap <silent> j gj
    nnoremap <silent> k gk

    " auto center {{{3
    nnoremap <silent> n nzz
    nnoremap <silent> N Nzz
    nnoremap <silent> * *zz
    nnoremap <silent> # #zz
    nnoremap <silent> g* g*zz
    nnoremap <silent> g# g#zz
    nnoremap <silent> <C-o> <C-o>zz
    nnoremap <silent> <C-i> <C-i>zz
    "}}}3

    " change cursor position in insert mode
    " delimitMate might sabotage this map
    " (or some other plugin maybe?)
    " inoremap <C-h> <left>
    inoremap <C-l> <right>
    " easy paste
    inoremap <C-q> <C-r><C-p>+

    " folds {{{3
    nnoremap zr zr:echo 'foldlevel: ' . &foldlevel<cr>
    nnoremap zm zm:echo 'foldlevel: ' . &foldlevel<cr>
    nnoremap zR zR:echo 'foldlevel: ' . &foldlevel<cr>
    nnoremap zM zM:echo 'foldlevel: ' . &foldlevel<cr>
    " show me only THIS fold
    nnoremap <leader>z zMzvzz
    " nnoremap zj :<C-u>silent! normal! zc<CR>zjzo
    " nnoremap zk :<C-u>silent! normal! zc<CR>zkzo[z
    " }}}3

    " reselect visual block after indent
    vnoremap < <gv
    vnoremap > >gv

    " reselect last paste
    nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

    " language switching
    nmap <M-z> a<C-^><Esc>
    if !s:is_gui
      " lang switch terminal edition
      nmap <C-Space> a<C-^><Esc>
      vmap <silent> <C-Space> <Esc>a<C-^><Esc>gv
    endif

    " smash escape
    " use only with 'timeout' and 'timeoutlen'
    inoremap jk <esc>

  " }}}2
  "==============================
  " | III -- Unused -- {{{2     |
  "==============================

    " sane regex {{{3
    nnoremap / /\v
    vnoremap / /\v
    nnoremap ? ?\v
    vnoremap ? ?\v
    nnoremap :s/ :s/\v
    "}}}3

    " Easier formatting
    " nnoremap <silent> <leader>q gwip
    " Fast bracketing
    " inoremap {{ {<CR>}<ESC>kA| "}} because it's parsed as foldmarker :\
    " consistent menu navigation
    " https://github.com/jasonlong/dotfiles/blob/master/vimrc
  " }}}2
" }}}1

" from http://twily.info/.vimrc#view {{{
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=1
catch
endtry

" Return to last edit position when opening files (You want this!)
augroup thaw_file
  autocmd!

  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal! g`\"" |
      \ endif
augroup END
" Remember info about open buffers on close
set viminfo^=%

"}}}

if has('virtualedit')
  set virtualedit=block               " allow cursor to move where there is no text in visual block mode
endif

" Allows you to visually select a section and then hit @ to run a macro on all lines
" https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db#.3dcn9prw6
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
function! SetRandomColors()
  if !exists('g:mycolors')
    " echo "* Fetching colorschemes..."
    " let g:mycolors = split(globpath(&rtp,"**/colors/*.vim"),"\n")
    let matches = {}
    for fname in split(globpath(&runtimepath, 'colors/*.vim'), '\n')
      let name = fnamemodify(fname, ':t:r')
      let matches[name] = 1
    endfor
    let g:mycolors = sort(keys(matches), 1)
  endif
  exe 'colorscheme ' . g:mycolors[localtime() % len(g:mycolors)]
  " unlet s:mycolors
  call SetCursorModes()
  redraw
  " echo "* color: " g:colors_name
  if has('title')
    set titlelen=99
    set titlestring=%t%(\ %M%)\ -%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{g:colors_name}
    " set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)\ -\ %{g:colors_name} titlelen=99
  endif
endfunction
command! Rcl call SetRandomColors()
map <F9> :call SetRandomColors()<CR>

" anzu mapping {{{
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
Plug 'jceb/vim-hier'
Plug 'osyo-manga/vim-agrep'
" anzu }}}

" Mode aware cursor hack {{{1
" works only if placed here?
" http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
" https://github.com/blaenk/dots/blob/9843177fa6155e843eb9e84225f458cd0205c969/vim/vimrc.ln#L49-L64
set gcr=a:block

" mode aware cursors
set gcr+=o:hor50-Cursor
set gcr+=n:Cursor
set gcr+=i-ci-sm:InsertCursor
set gcr+=r-cr:ReplaceCursor-hor20
set gcr+=c:CommandCursor
set gcr+=v-ve:VisualCursor

" do not blink
set gcr+=a:blinkon0
function! SetCursorModes()
  hi InsertCursor  ctermfg=15 guifg=#fdf6e3 ctermbg=37  guibg=#2aa198
  hi VisualCursor  ctermfg=15 guifg=#fdf6e3 ctermbg=125 guibg=#d33682
  hi ReplaceCursor ctermfg=15 guifg=#fdf6e3 ctermbg=65  guibg=#dc322f
  hi CommandCursor ctermfg=15 guifg=#fdf6e3 ctermbg=166 guibg=#cb4b16
endfunction
call SetCursorModes()
" }}}1
if s:is_gui
  call SetRandomColors()
endif
