set colorcolumn=81

" Do not spell comments in LaTex
let g:vimtex_syntax_nospell_comments=1


" Only check spelling in LaTex files
" autocmd BufRead,BufNewFile *.tex set spelllang=en,es spell

vnoremap <leader>i c\textit{<c-r>"}
vnoremap <leader>b c\textbf{<c-r>"}
vnoremap <leader>v c\verb\|<c-r>"\|

inoremap ºv \verb\|\|<left>
inoremap ºi \textit{}<left>
inoremap ºb \textbf{}<left>
inoremap ºc ~\cite{}<left>
inoremap ºr ~\ref{}<left>
inoremap ºfu \footnote{\url{}}<left><left>
nnoremap <leader>x :!./compile<CR>
nnoremap <leader>. f.lxi<CR><ESC>
