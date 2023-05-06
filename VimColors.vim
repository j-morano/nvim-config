"---- Builtins
" Soft hl color
hi Search guibg=#d7d7ff
" " True black text
hi Normal guifg=#303030
hi NormalFloat guifg=#303030 guibg=#dadada
hi NormalNC guifg=#303030
" " Line numbers
hi LineNr guifg=#808080
hi LineNrAbove guifg=#808080
hi LineNrBelow guifg=#808080
" Cursor line
hi CursorLine guibg=#e8e8e8
hi ColorColumn guibg=lightgrey
hi BufferManagerModified guifg=#0000af

" Spelling
hi SpellBad guibg=#ffafd7

"---- Custom PaperColor highlights
" Markdown
" hi markdownCodeBlock guifg=#000000
" " Dark green strings
" hi String guifg=#005f00
" hi pythonString guifg=#005f00
" hi jsxString guifg=#005f00
" hi jsonString guifg=#005f00
" hi xmlString guifg=#005f00

"---- LSP
hi TypeHints guibg=#dfdfff
hi ClosingTags cterm=bold guifg=#808080 gui=bold

"---- IndentBlankLine
hi IndentBlanklineIndent1 cterm=nocombine guifg=#a8a8a8 gui=nocombine
hi IndentBlanklineIndent2 cterm=nocombine guifg=#af87af gui=nocombine
hi IndentBlanklineIndent3 cterm=nocombine guifg=#87afff gui=nocombine
hi IndentBlanklineIndent4 cterm=nocombine guifg=#dfaf5f gui=nocombine
hi IndentBlanklineIndent5 cterm=nocombine guifg=#ff8787 gui=nocombine
hi IndentBlanklineIndent6 cterm=nocombine  guifg=#5faf87 gui=nocombine

"---- Fugitive
hi diffAdded guifg=#005f00 guibg=none
hi diffRemoved guifg=#870000 guibg=none

"---- Highlight trailing spaces
hi EoLSpace guibg=#dfafdf
autocmd Syntax * syntax match EoLSpace /\s\+$/

"---- Highlight trailing tabs
highlight CopilotSuggestion guifg=#9c4fb8 
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
