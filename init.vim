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

lua << EOF
---- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  ['<TAB>'] = cmp.mapping.select_next_item(),
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  -- { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
  { name = 'nvim_lsp_signature_help' },
  { name = 'path' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

---- LSP
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require'lspconfig'.pylsp.setup({
    cmd={"python3", "-m", "pylsp"},
    settings = {
        pylsp = {
            plugins={
                pycodestyle={
                    enabled=false
                }
            }
        }
    },
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
})
require'lspconfig'.texlab.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
})
require'lspconfig'.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
})

require('rust-tools').setup({
    tools = {
        inlay_hints = {
            highlight = "LspDiagnosticsDefaultHint"
        }
    }
})
require "lsp_signature".setup({
    floating_window = false,
})
EOF

let g:cursorword_highlight = 0
let g:cursorword_delay = 0

augroup cursorword
  autocmd!
  autocmd VimEnter,ColorScheme * highlight CursorWord0 ctermbg=254
augroup END


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

" Show a few lines of context around the cursor. Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=0

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


" Break indent
set breakindent
set showbreak=>>


" Soft word wrap
set wrap linebreak


" Always show 2 sign columns
set signcolumn=yes


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

" Move cursor up and down in the visible area.
" nnoremap <Up> gk
" nnoremap <Down> gj
" inoremap <Up> <C-o>gk
" inoremap <Down> <C-o>gj
" Move cursor by display lines
"nnoremap k gk
"nnoremap j gj
"vnoremap k gk
"vnoremap j gj
"inoremap <C-k> <C-o>gk
"inoremap <C-j> <C-o>gj
" Jump regular lines when using numbers
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'


" Alternative enter (sometimes useful to avoid keymaps)
"  E.g. with the autocompletion.
inoremap <C-o> <CR>


" Wildmode to last used
set wildmode=full:lastused


vnoremap "" c"<c-r>""<esc>
vnoremap '' c'<c-r>"'<esc>

" Add blank line below
nnoremap _ o<Esc>k


" Remove trailing spaces
command RmTrail :%s/\s\+$//e


" Show relative numbers
set relativenumber


" Custom tabspaces values
"autocmd FileType yaml setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab


" Ignore case in searches.
set ignorecase
" Override the 'ignorecase' option if the search pattern contains upper
"  case characters. Only used when the search pattern is typed and
"  'ignorecase' option is on.
set smartcase


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


" Show tabline
set showtabline=1


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


" Open splits to the right and below
set splitright
set splitbelow


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
