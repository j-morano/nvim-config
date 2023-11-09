require("tokyonight").setup({
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = false },
    keywords = { italic = false },
    functions = { italic = false }
  },
  -- Black variable names
  on_highlights = function (hl, _)
    hl["@variable"].fg = "#ffffff"
  end
})

local function set_custom_highlights()
  -- Soft hl color
  vim.api.nvim_set_hl(0, "Search", { bg = "#d7d7ff" })
  vim.api.nvim_set_hl(0, "CurSearch", { bg = "#d7d7ff" })
  vim.api.nvim_set_hl(0, "IncSearch", { bg = "#000000", fg = "#ffffff" })
  -- True black text
  vim.api.nvim_set_hl(0, "Normal", { fg = "#303030" })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#303030", bg = "#dadada" })
  vim.api.nvim_set_hl(0, "NormalNC", { fg = "#303030" })
  -- Line numbers
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#808080" })
  vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#808080" })
  vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#808080" })
  -- Cursor line
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#e8e8e8" })
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "lightgrey" })
  vim.api.nvim_set_hl(0, "BufferManagerModified", { fg = "#0000af" })

  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#424242" })

  -- Spelling
  vim.api.nvim_set_hl(0, "SpellBad", { bg = "#ffafd7" })

  -- LSP
  vim.api.nvim_set_hl(0, "TypeHints", { bg = "#dfdfff" })
  vim.api.nvim_set_hl(0, "ClosingTags", { fg = "#808080", bold = true })

  -- Fugitive
  vim.api.nvim_set_hl(0, "diffAdded", { fg = "#005f00", bg = "none" })
  vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#870000", bg = "none" })

  -- Listchars
  vim.api.nvim_set_hl(0, "Whitespace", { fg = "#ffafd7", bg = "#ffafd7" })

  -- Copilot
  vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#9c4fb8" })

  ---- IndentBlankLine
  vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#a8a8a8", nocombine = true })
  vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#af87af", nocombine = true })
  vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg = "#87afff", nocombine = true })
  vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg = "#dfaf5f", nocombine = true })
  vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg = "#ff8787", nocombine = true })
  vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { fg = "#5faf87", nocombine = true })
end


-- Some colorschemes use the ':hi clear' command to clear all custom highlight
-- and reset highlighting to the defaults.
-- In this cases, custom highlights do not work anymore. A solution is to use a
-- special event ColorScheme, which is triggered whenever we change the
-- colorscheme. After changing the color scheme, we redefine the custom
-- highlight group.
local au_id = vim.api.nvim_create_augroup("custom_highlight", {clear = true})
vim.api.nvim_create_autocmd("ColorScheme",{
  callback = set_custom_highlights,
  group = au_id
})


vim.opt.background = "light"
vim.cmd.colorscheme("tokyonight-day")


---- Terminal colors
vim.g.terminal_color_0 = "#212121"
vim.g.terminal_color_8 = "#424242"
vim.g.terminal_color_1 = "#b7141e"
vim.g.terminal_color_9 = "#e83a3f"
vim.g.terminal_color_2 = "#457b23"
vim.g.terminal_color_10 = "#7aba39"
vim.g.terminal_color_3 = "#a36500"
vim.g.terminal_color_11 = "#fee92e"
vim.g.terminal_color_4 = "#134eb2"
vim.g.terminal_color_12 = "#53a4f3"
vim.g.terminal_color_5 = "#550087"
vim.g.terminal_color_13 = "#a94dbb"
vim.g.terminal_color_6 = "#0e707c"
vim.g.terminal_color_14 = "#26bad1"
vim.g.terminal_color_7 = "#eeeeee"
vim.g.terminal_color_15 = "#d8d8d8"


-- Highlight trailing whitespace except in insert mode
vim.cmd[[
autocmd InsertEnter * set listchars=
autocmd InsertLeave * set listchars=trail:-
set list
]]
