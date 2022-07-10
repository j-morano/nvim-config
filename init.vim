" Custom init.vim file.
"
" Maintainer:	José Morano <j.morano@udc.es>


lua require('plugins')
lua require('init')

augroup cursorword
  autocmd!
  autocmd VimEnter,ColorScheme * highlight CursorWord0 ctermbg=254
augroup END


" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>


" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif


" ====================================================================
" Added


" Vertical rulers for Python
autocmd FileType python set colorcolumn=73,80
autocmd FileType rust set colorcolumn=81,101
autocmd FileType javascript set colorcolumn=81
" Custom tabspaces values
"autocmd FileType yaml setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab


" Colorscheme
set background=light
colorscheme PaperColor
" Use terminal background color
highlight Normal ctermfg=NONE ctermbg=NONE
highlight LineNr ctermbg=NONE
highlight NonText ctermbg=NONE


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


vnoremap "" c"<c-r>""<esc>
vnoremap '' c'<c-r>"'<esc>


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


" When switching buffers, preserve window view.
if v:version >= 700
    au BufLeave * if !&diff | let b:winview = winsaveview() | endif
    au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | endif
endif
