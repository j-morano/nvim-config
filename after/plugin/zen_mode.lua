require("zen-mode").setup {
  window = {
    width = 120,
    options = {
      number = true,
      relativenumber = true,
    }
  },
}


---- Keybindings
local map = vim.keymap.set
local opts = {noremap = true}--, silent = true}

-- Center buffer
map("n", "<leader>zz", require("zen-mode").toggle, opts)
