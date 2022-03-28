" Custom vimrc file.
"
" Maintainer:	José Morano <j.morano@udc..es>
"
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.


" Disable indentLine plugin for certain file types
let g:indentLine_fileTypeExclude = ['tex', 'markdown', 'json']


" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/installed_plugins')

" Make sure you use single quotes

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Track the engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

Plug 'airblade/vim-gitgutter' 

Plug 'NLKNguyen/papercolor-theme'

Plug 'lervag/vimtex'

Plug 'antoinemadec/FixCursorHold.nvim'

Plug 'Vimjas/vim-python-pep8-indent'

"Plug 'vim-airline/vim-airline'

"Plug 'vim-airline/vim-airline-themes'

Plug 'sheerun/vim-polyglot'

Plug 'Yggdroot/indentLine'

" Plug 'github/copilot.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ThePrimeagen/harpoon'

" Initialize plugin system
call plug#end()


" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal


" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif


" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
" Revert with ":filetype off".
filetype plugin indent on

" Put these in an autocmd group, so that you can revert them with:
" ":augroup vimStartup | au! | augroup END"
augroup vimStartup
au!

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

augroup END


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
            \ | wincmd p | diffthis
endif


" ====================================================================
" Added

" Encoding
set encoding=utf-8

" Save on exit insert mode
" autocmd InsertLeave * update

" Save on double s
" nnoremap s <NOP>
" nmap ss :update<CR>
" Save on single 's'
nnoremap s :update<CR>


" Show line numbers
set number

" Status line
set laststatus=2

" Vertical rulers for Python
autocmd FileType python set colorcolumn=73,80
autocmd FileType rust set colorcolumn=81,101
autocmd FileType javascript set colorcolumn=81


" Colorscheme
set background=light
colorscheme PaperColor
" Use terminal background color
highlight Normal ctermfg=NONE ctermbg=NONE
highlight LineNr ctermbg=NONE
highlight NonText ctermbg=NONE

" Tabs as spaces
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab smartindent


" Soft word wrap
set wrap linebreak


" Make the left and right arrow keys change line
set whichwrap+=<,>,[,],h,l

" Copy to system clipboard
" Dependency: clipboard software. For example: xclip
set clipboard+=unnamedplus

" Higlight current word occurences
" set hlsearch
nnoremap * *N
nnoremap _ :noh<CR>
set nohlsearch

" Custom hjkl remap
noremap ñ h
nnoremap Ñ :
nnoremap qÑ q:
nnoremap @Ñ @:
nnoremap <C-w>ñ <C-w>h

" Move cursor up and down in the visible area.
" nnoremap <Up> gk
" nnoremap <Down> gj
" inoremap <Up> <C-o>gk
" inoremap <Down> <C-o>gj
" Move cursor by display lines
nnoremap k gk
nnoremap j gj
vnoremap k gk
vnoremap j gj
inoremap <C-k> <C-o>gk
inoremap <C-j> <C-o>gj
" Jump regular lines when using numbers
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Smooth mouse scroll
" map <ScrollWheelUp> <C-y>
" map <ScrollWheelDown> <C-e>


" Add blank line below
nnoremap - o<Esc>k


" Remove trailing spaces
command RmTrail :%s/\s\+$//e


" Use <C-r> to trigger completion.
inoremap <silent><expr> <C-r> coc#refresh()

" Trigger signature help
inoremap <C-p> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<cr>

" Show relative numbers
set relativenumber

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Custom tabspaces values
"autocmd FileType yaml setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()


" Ignore case in searches.
set ignorecase
" Override the 'ignorecase' option if the search pattern contains upper
"  case characters. Only used when the search pattern is typed and
"  'ignorecase' option is on.
set smartcase


" coc.nvim auxiliary functions
function! CocSearchCurrentWord()
  let currentword = expand("<cword>")
  :echo currentword
  :execute ":CocSearch " . currentword
endfunction

" coc.nvim commands
" github.com/neoclide/coc.nvim/blob/9f6e29b6f9661ebba10ff3df84de11d96c8a9e56/doc/coc.txt
" GoTo code navigation.
command Refs call CocAction("jumpReferences")
command Imp call CocAction("jumpImplementation")
command Def call CocAction("jumpDefinition")
command Dec call CocAction("jumpDeclaration")
" Other actions
" command Ren call CocAction("rename")
command Ref call CocAction("refactor")
command Form call CocAction("format")
command Sea call CocSearchCurrentWord()


" Use <C-l> for trigger snippet expand.
let g:UltiSnipsExpandTrigger = '<C-l>'


" Replace currently selected text with default register
"  without yanking it
vnoremap p "_dP
noremap c "_c


" Enable highlight current symbol on CursorHold:
autocmd CursorHold * silent call CocActionAsync('highlight')

" in millisecond, used for both CursorHold and CursorHoldI,
" use updatetime instead if not defined
let g:cursorhold_updatetime = 100


" Show tabline
set showtabline=1

" Airline configuration
"let g:airline_theme='papercolor'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline_powerline_fonts = 1


" Switch arrow key mappings for wildmenu tab completion
set wildcharm=<C-Z>
cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> wildmenumode() ? "<space>\<bs>\<C-Z>" : "\<right>"
cnoremap <expr> <CR> wildmenumode() ? "<space>\<bs>\<C-Z>" : "\<CR>"


" Switch buffer even if it is not saved
set hidden


" Save marks and other information between sessions
set viminfo='100,f1
" nnoremap ' `
" nnoremap ` '
nnoremap <silent> <expr> ' "`".toupper(nr2char(getchar()))
nnoremap <silent> <expr> m "m".toupper(nr2char(getchar()))


" Enable copilot for certain file types only
let g:copilot_filetypes = {
    \ '*': v:false,
    \ 'python': v:true,
    \ 'javascript': v:true,
\ }


" Resize Neovim itself when launched as initial command for terminal
autocmd VimEnter * :sleep 100m
autocmd VimEnter * silent exec "!kill -s SIGWINCH" getpid()


" Terminal
" Start directly in insert mode
autocmd TermOpen * startinsert
" Exit terminal mode with ESC
:tnoremap <Esc> <C-\><C-n>
" Airline: show terminal buffer title
"let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'

" Map leader to space
let mapleader = " "


" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


" Move between buffers
nnoremap <leader>p :bp<CR>
nnoremap <leader>n :bn<CR>
nnoremap <leader><leader> :buffers<CR>:b<space>


" Search and replace selected text starting from the cursor position
" sno: nomagic: do not use regex
vnoremap <C-r> "hy:,$sno/<C-r>h//gc<left><left><left>


" Yank a region without moving the cursor to the top of the block
vmap y ygv<Esc>


" Show trailing spaces
set listchars=trail:@
" set list


" Do not leave scroll margins
set scrolloff=0


" Fast repeat macro
nnoremap ¡ @q


" Remap increase number
nnoremap <C-c> <C-a>

" --- Harpoon ---
nnoremap <leader>o :lua require("harpoon.ui").toggle_quick_menu()<cr>
nnoremap <leader>a :lua require("harpoon.mark").add_file()<cr>
nnoremap <leader>j :lua require("harpoon.ui").nav_next()<cr>
nnoremap <leader>k :lua require("harpoon.ui").nav_prev()<cr>
nnoremap <leader>1 :lua require("harpoon.ui").nav_file(1)<cr>
nnoremap <leader>2 :lua require("harpoon.ui").nav_file(2)<cr>
nnoremap <leader>3 :lua require("harpoon.ui").nav_file(3)<cr>
nnoremap <leader>4 :lua require("harpoon.ui").nav_file(4)<cr>


" --- Best remaps ever ---

" Behave Vim
nnoremap Y yg$

" Keeping it centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" When switching buffers, preserve window view.
if v:version >= 700
    au BufLeave * if !&diff | let b:winview = winsaveview() | endif
    au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | endif
endif
