" Custom init.vim file.
"
" Maintainer:	José Morano <j.morano@udc.es>


lua require('plugins')
lua require('init')


" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif


" Vertical rulers for Python
autocmd FileType python set colorcolumn=73,80
autocmd FileType rust set colorcolumn=81,101
autocmd FileType javascript set colorcolumn=81
autocmd FileType tex set colorcolumn=81
" Custom tabspaces values
"autocmd FileType yaml setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab


" Auto-expansion
inoremap (<CR> (<CR>)<C-c>O
inoremap {<CR> {<CR>}<C-c>O
inoremap [<CR> [<CR>]<C-c>O
inoremap (<Space> ()<Left>
inoremap {<Space> {}<Left>
inoremap [<Space> []<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ` ``<Left>


" Colorscheme
set background=light
" Use terminal background color
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }
colorscheme PaperColor


" Custom colors
runtime VimColors.vim


" Resize Neovim itself when launched as initial command for terminal
autocmd VimEnter * :sleep 100m
autocmd VimEnter * silent exec "!kill -s SIGWINCH" getpid()


" Terminal
" Start directly in insert mode
autocmd TermOpen term://* startinsert
autocmd TermOpen term://* setlocal nonumber norelativenumber
autocmd BufEnter term://* startinsert
" Exit terminal mode with ESC
tnoremap <M-x> <C-\><C-n>
tnoremap <M-q> <C-\><C-n>:wincmd p<CR>
tnoremap <M-w> <C-\><C-n>:e#<CR>
nnoremap <C-t> <cmd>sp <bar> res 10 <bar> te<CR>


" When switching buffers, preserve window view.
if v:version >= 700
    au BufLeave * if !&diff | let b:winview = winsaveview() | endif
    au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | endif
endif


" Wildmenu invoking keybinding
set wildcharm=<C-Z>
" Switch arrow key mappings for wildmenu tab completion
cnoremap <expr> <CR> wildmenumode() ? "<space>\<bs>\<C-Z>" : "\<CR>"
cnoremap <expr> ç wildmenumode() ? "\<up>" : "ç"

" Move cursor by display lines
" Jump regular lines when using numbers
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'

" Always use global marks
nnoremap <silent> <expr> ' "`" . toupper(nr2char(getchar())) . 'zz'
nnoremap <silent> <expr> m "m" . toupper(nr2char(getchar()))

" Search and replace selected text starting from the cursor position
" \V: very nomagic: do not use regex
vnoremap <C-r> "hy:,$s/\V<C-r>h//gc<left><left><left>


"--- Vim-style alternative to multiple cursors
" Apply macro to given word
nnoremap qi <cmd>let @/='\<'.expand('<cword>').'\>'<cr>wbqi
xnoremap qi y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>qi
nnoremap <C-s> n@i

" Close buffer without closing window
command BD bp | sp | bn | bd
