"---- Builtins
" Soft hl color
hi Search ctermbg=189 guibg=#d7d7ff
" " True black text
hi Normal ctermfg=236 guifg=#303030
hi NormalFloat ctermfg=236 ctermbg=253 guifg=#303030 guibg=#dadada
hi NormalNC ctermfg=236 guifg=#303030
" " Line numbers
hi LineNr ctermfg=244 guifg=#808080
hi LineNrAbove ctermfg=244 guifg=#808080
hi LineNrBelow ctermfg=244 guifg=#808080
" Cursor line
hi CursorLine ctermbg=255 guibg=#e8e8e8
hi ColorColumn ctermbg=lightgrey guibg=lightgrey

" Spelling
hi SpellBad ctermbg=218 guibg=#ffafd7

"---- Custom PaperColor highlights
" Markdown
" hi markdownCodeBlock ctermfg=0 guifg=#000000
" " Dark green strings
" hi String ctermfg=22 guifg=#005f00
" hi pythonString ctermfg=22 guifg=#005f00
" hi jsxString ctermfg=22 guifg=#005f00
" hi jsonString ctermfg=22 guifg=#005f00
" hi xmlString ctermfg=22 guifg=#005f00

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
autocmd Syntax * syntax match EoLSpace /\s\+$/

"---- Highlight trailing tabs
highlight CopilotSuggestion guifg=#9c4fb8 ctermfg=54

"---- Terminal colors
let g:terminal_color_0 = '#212121'
let g:terminal_color_8 = '#424242'
let g:terminal_color_1 = '#b7141e'
let g:terminal_color_9 = '#e83a3f'
let g:terminal_color_2 = '#457b23'
let g:terminal_color_10= '#7aba39'
let g:terminal_color_3 = '#a36500'
let g:terminal_color_11= '#fee92e'
let g:terminal_color_4 = '#134eb2'
let g:terminal_color_12= '#53a4f3'
let g:terminal_color_5 = '#550087'
let g:terminal_color_13= '#a94dbb'
let g:terminal_color_6 = '#0e707c'
let g:terminal_color_14= '#26bad1'
let g:terminal_color_7 = '#eeeeee'
let g:terminal_color_15= '#d8d8d8'
