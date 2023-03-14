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
