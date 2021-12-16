set colorcolumn=81

" Do not spell comments in LaTex
let g:vimtex_syntax_nospell_comments=1


" Only check spelling in LaTex files
" autocmd BufRead,BufNewFile *.tex set spelllang=en,es spell

nnoremap <leader>i i\textit{}<ESC>i
nnoremap <leader>b i\textbf{}<ESC>i
nnoremap <leader>z i\begin{itemize}<CR>\item <CR>\end{itemize}<ESC><<<kA
