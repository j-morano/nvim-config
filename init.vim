" Custom vimrc file.
"
" Maintainer:	José Morano <j.morano@udc..es>


" Disable indentLine plugin for certain file types
let g:indentLine_fileTypeExclude = ['tex', 'markdown', 'json']


" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/installed_plugins')

" Make sure you use single quotes

" Track the engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

"Plug 'mhinz/vim-signify'
Plug 'airblade/vim-gitgutter'

Plug 'NLKNguyen/papercolor-theme'

Plug 'lervag/vimtex'

Plug 'antoinemadec/FixCursorHold.nvim'

Plug 'Vimjas/vim-python-pep8-indent'

Plug 'ray-x/lsp_signature.nvim'

Plug 'sheerun/vim-polyglot'

Plug 'Yggdroot/indentLine'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ThePrimeagen/harpoon'

Plug 'neovim/nvim-lspconfig'

Plug 'simrat39/rust-tools.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'

Plug 'itchyny/vim-cursorword'

" Initialize plugin system
call plug#end()

lua require('init')

let g:cursorword_highlight = 0
let g:cursorword_delay = 0

augroup cursorword
  autocmd!
  autocmd VimEnter,ColorScheme * highlight CursorWord0 ctermbg=254
augroup END


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

" Save on exit insert mode
" autocmd InsertLeave * update

" Save on single 's'
nnoremap s :update<CR>


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


" Make the left and right arrow keys change line
set whichwrap+=<,>,[,],h,l

" Copy to system clipboard
" Dependency: clipboard software. For example: xclip
set clipboard+=unnamedplus

" Higlight current word occurences
" set hlsearch
"nnoremap * *N
nnoremap _ :noh<CR>
set nohlsearch

" Custom hjkl remap
noremap ñ h
nnoremap Ñ :
vnoremap Ñ :
nnoremap qÑ q:
nnoremap @Ñ @:
nnoremap <C-w>ñ <C-w>h

" Move cursor by display lines
" Jump regular lines when using numbers
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'


" Alternative enter (sometimes useful to avoid keymaps)
"  E.g. with the autocompletion.
inoremap <C-o> <CR>


vnoremap "" c"<c-r>""<esc>
vnoremap '' c'<c-r>"'<esc>

" Add blank line below
nnoremap _ o<Esc>k


" Remove trailing spaces
command RmTrail :%s/\s\+$//e


" Custom tabspaces values
"autocmd FileType yaml setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab


" Use <C-l> for trigger snippet expand.
let g:UltiSnipsExpandTrigger = '<C-l>'


" Replace currently selected text with default register
"  without yanking it
vnoremap p "_dP
noremap c "_c


" in millisecond, used for both CursorHold and CursorHoldI,
" use updatetime instead if not defined
let g:cursorhold_updatetime = 100
" default updatetime 4000ms is not good for async update
set updatetime=100


" Switch arrow key mappings for wildmenu tab completion
set wildcharm=<C-Z>
cnoremap <expr> <up> wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> wildmenumode() ? "<space>\<bs>\<C-Z>" : "\<right>"
cnoremap <expr> <CR> wildmenumode() ? "<space>\<bs>\<C-Z>" : "\<CR>"


" Save marks and other information between sessions
set viminfo='100,f1
" nnoremap ' `
" nnoremap ` '
nnoremap <silent> <expr> ' "`" . toupper(nr2char(getchar())) . 'zz'
nnoremap <silent> <expr> m "m" . toupper(nr2char(getchar()))


" Resize Neovim itself when launched as initial command for terminal
autocmd VimEnter * :sleep 100m
autocmd VimEnter * silent exec "!kill -s SIGWINCH" getpid()


" Terminal
" Start directly in insert mode
autocmd TermOpen * startinsert
" Exit terminal mode with ESC
:tnoremap <Esc> <C-\><C-n>

" Map leader to space
let mapleader = " "


" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fr <cmd>Telescope resume<cr>


" Move between buffers
nnoremap <leader><leader> :buffers<CR>:b<space>


function IsFile()
    if filereadable(expand('<cfile>'))
        return 1
    endif
    if isdirectory(expand('<cfile>'))
        return 1
    endif
    return 0
endfunction


" Check if file under cursor exists
nnoremap <leader>e :echo IsFile() ? 'exists' : 'does not exist'<cr>


" More comfortable keybindig for alternate-file
inoremap <M-w> <ESC>:e#<CR>a
nnoremap <M-w> <ESC>:e#<CR>


" Search and replace selected text starting from the cursor position
" \V: very nomagic: do not use regex
vnoremap <C-r> "hy:,$s/\V<C-r>h//gc<left><left><left>


" -- Vim-style alternative to multiple cursors
" You can change a whole word by pressing <leader>s, or if you only want to change
" a few characters, visually select them and then press <leader>s. This changes
" just the word/selection under the cursor; to repeat the change,
" press . (dot), which searches for the next match and changes it in one go.
nnoremap <silent> <leader>s :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> <leader>s "sy:let @/=@s<CR>cgn


" Yank a region without moving the cursor to the top of the block
vmap y ygv<Esc>


" Show trailing spaces
set listchars=trail:@
" set list


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


" Highlight NOTE
call matchadd('Todo', 'NOTE')


" Alternative escape
inoremap jj <Esc>


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
