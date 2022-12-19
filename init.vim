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

" When switching buffers, preserve window view.
au BufLeave * if !&diff | let b:winview = winsaveview() | endif
au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | endif


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


" Switch arrow key mappings for wildmenu tab completion
cnoremap <expr> <CR> wildmenumode() ? "<space>\<bs>\<C-Z>" : "\<CR>"
cnoremap <expr> <M-ñ> wildmenumode() ? "\<up>" : "\<M-ñ>"

"--- Vim-style alternative to multiple cursors
" Apply macro to given word
nnoremap qi <cmd>let @/='\<'.expand('<cword>').'\>'<cr>wbqi
xnoremap qi y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>qi
nnoremap <C-s> n@i
