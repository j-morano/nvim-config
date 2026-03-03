require("tokyonight").setup({
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = false },
    keywords = { italic = false },
    functions = { italic = false }
  },
  day_brightness = 0.25,
  terminal_colors = false,
  -- Black variable names
  on_highlights = function (hl, _)
    hl["@variable"].fg = "#000000"
  end
})

local function set_custom_highlights()
  -- Soft hl color
  vim.api.nvim_set_hl(0, "Search", { bg = "#d7d7ff" })
  vim.api.nvim_set_hl(0, "CurSearch", { bg = "#d7d7ff" })
  vim.api.nvim_set_hl(0, "IncSearch", { bg = "#000000", fg = "#ffffff" })
  -- True black text
  vim.api.nvim_set_hl(0, "Normal", { fg = "#000000" }) --, bg = "#e1e2e7" })
  vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#000000", bg = "#dadada" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#000000", bg = "#dadada" })
  vim.api.nvim_set_hl(0, "NormalNC", { fg = "#000000" })
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

  -- Add Critical highlight group in red
  vim.api.nvim_set_hl(0, "Critical", {fg = "#ffffff", bg = "#bb0000", bold = true })
end


---- IndentBlankLine
vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#a8a8a8", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#af87af", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg = "#87afff", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg = "#dfaf5f", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg = "#ff8787", nocombine = true })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { fg = "#5faf87", nocombine = true })


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


require('gitsigns').setup({
  signs = {
    add = { text = '+' }, -- The only change you wanted!
    change = { text = '~' },
    changedelete = { text = '>' },
    delete = { text = '-' },
  },
})

-- Define the highlight groups for gitsigns
local git_high_contrast = {
  -- Black on Green
  GitSignsAdd    = { fg = '#000000', bg = '#d0f1d4', bold = true },
  -- Black on Blue
  GitSignsChange = { fg = '#000000', bg = '#bdd8ff', bold = true },
  -- Black on Red
  GitSignsDelete = { fg = '#000000', bg = '#ffbdbd', bold = true },
  -- Black on Purple
  GitSignsChangedelete = { fg = '#000000', bg = '#e9bdff', bold = true },
}

for group, settings in pairs(git_high_contrast) do
  vim.api.nvim_set_hl(0, group, settings)
end


-- Highlight trailing whitespace except in insert mode
vim.cmd[[
autocmd InsertEnter * set listchars=
autocmd InsertLeave * set listchars=trail:-
set list
]]
