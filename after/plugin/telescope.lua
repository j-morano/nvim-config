require "telescope".setup {
  pickers = {
    buffers = {
      initial_mode = "normal"
    },
  }
}


local map = vim.keymap.set
local opts = {noremap = true}

-- Telescope keybindings
local telescope = require('telescope.builtin')
map('n', '<leader>o', telescope.find_files, opts)
map('n', '<leader>fg', telescope.live_grep, opts)
map('n', '<leader>fh', telescope.help_tags, opts)
map('n', '<leader>fb', telescope.buffers, opts)
map('n', '<leader>fr', telescope.resume, opts)
