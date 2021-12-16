set colorcolumn=81

" Do not spell comments in LaTex
let g:vimtex_syntax_nospell_comments=1


" Only check spelling in LaTex files
" autocmd BufRead,BufNewFile *.tex set spelllang=en,es spell

nnoremap <leader>i a\textit{}<ESC>i
nnoremap <leader>b a\textbf{}<ESC>i
nnoremap <leader>c a\cite{}<ESC>i
nnoremap <leader>r a\ref{}<ESC>i
nnoremap <leader>fu a\footnote{\url{}}<ESC>hi
nnoremap <leader>z a\begin{itemize}<CR>\item <CR>\end{itemize}<ESC><<<kA
nnoremap <leader>x :!./compile
