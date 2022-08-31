"---- Builtins
" Soft hl color
hi Search ctermbg=254 guibg=#e4e4e4
" True black text
hi Normal ctermfg=0 guifg=#000000
hi NormalFloat ctermfg=0 ctermbg=253 guifg=#000000 guibg=#dadada
hi NormalNC ctermfg=0 guifg=#000000
" Line numbers
hi LineNr ctermfg=244 guifg=#808080
hi LineNrAbove ctermfg=244 guifg=#808080
hi LineNrBelow ctermfg=244 guifg=#808080
" Cursor line
hi CursorLine ctermbg=255 guibg=#eeeeee

"---- Custom PaperColor highlights
" Markdown
hi markdownCodeBlock ctermfg=0 guifg=#000000
" Dark green strings
hi String ctermfg=22 guifg=#005f00
hi pythonString ctermfg=22 guifg=#005f00
hi jsxString ctermfg=22 guifg=#005f00
hi jsonString ctermfg=22 guifg=#005f00
hi xmlString ctermfg=22 guifg=#005f00

"---- LSP
hi TypeHints ctermbg=189 guibg=#dfdfff
hi ClosingTags ctermfg=244 cterm=bold guifg=#808080 gui=bold

"---- IndentBlankLine
hi IndentBlanklineIndent1 ctermfg=248 cterm=nocombine guifg=#a8a8a8 gui=nocombine
hi IndentBlanklineIndent2 ctermfg=139 cterm=nocombine guifg=#af87af gui=nocombine
hi IndentBlanklineIndent3 ctermfg=111 cterm=nocombine guifg=#87afff gui=nocombine
hi IndentBlanklineIndent4 ctermfg=179 cterm=nocombine guifg=#dfaf5f gui=nocombine
hi IndentBlanklineIndent5 ctermfg=210 cterm=nocombine guifg=#ff8787 gui=nocombine
hi IndentBlanklineIndent6 ctermfg=72 cterm=nocombine  guifg=#5faf87 gui=nocombine

"---- Fugitive
hi diffAdded ctermfg=22 ctermbg=none guifg=#005f00 guibg=none
hi diffRemoved ctermfg=88 ctermbg=none guifg=#005f00 guibg=none

"---- Highlight trailing spaces
hi EoLSpace ctermbg=182 guibg=#dfafdf
match EoLSpace /\s\+$/
