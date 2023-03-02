" Only check spelling in LaTex files
" autocmd BufRead,BufNewFile *.tex set spelllang=en,es spell

vnoremap <leader>i c\textit{<c-r>"}<Esc>
vnoremap <leader>b c\textbf{<c-r>"}<Esc>
vnoremap <leader>u c\underline{<c-r>"}<Esc>
vnoremap <leader>v c\verb\|<c-r>"\|<Esc>

inoremap ¡v \verb\|\|<left>
inoremap ¡i \textit{}<left>
inoremap ¡u \underline{}<left>
inoremap ¡b \textbf{}<left>
inoremap ¡c ~\cite{}<left>
inoremap ¡r ~\ref{}<left>
inoremap ¡fu \footnote{\url{}}<left><left>
nnoremap <C-s> :update <bar> !./compile<CR>
nnoremap <leader>. f.lxi<CR><ESC>
