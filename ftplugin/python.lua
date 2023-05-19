local opts = {noremap = true, silent = true}
-- Write dictionary keyworkds
vim.api.nvim_set_keymap('i', '<C-d>', "['']<left><left>", opts)
-- Run current file
vim.api.nvim_set_keymap('n', '<M-p>', ':!python3 "%:p"<CR>', opts)
