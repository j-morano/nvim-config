local highlight = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
}

require("ibl").setup {
  indent = { highlight = highlight, char = "│" },
  whitespace = {
    highlight = highlight,
    remove_blankline_trail = false,
  },
  scope = {
    show_start = false,
    show_end = false,
    char = "┊",
  },
}
