-- Activate spell checking by default
-- vim.opt_local.spelllang = "en,es"
-- vim.opt_local.spell = true


local opts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('v', '<leader>i', "c\\textit{<c-r>\"}<Esc>", opts)
vim.api.nvim_set_keymap('v', '<leader>e', "c\\emph{<c-r>\"}<Esc>", opts)
vim.api.nvim_set_keymap('v', '<leader>b', "c\\textbf{<c-r>\"}<Esc>", opts)
vim.api.nvim_set_keymap('v', '<leader>m', "c\\mathbf{<c-r>\"}<Esc>", opts)
vim.api.nvim_set_keymap('v', '<leader>u', "c\\underline{<c-r>\"}<Esc>", opts)
vim.api.nvim_set_keymap('v', '<leader>v', "c\\verb\\|<c-r>\"\\|<Esc>", opts)

vim.api.nvim_set_keymap('i', '<v', "\\verb\\|\\|<left>", opts)
vim.api.nvim_set_keymap('i', '<i', "\\textit{}<left>", opts)
vim.api.nvim_set_keymap('i', '<e', "\\emph{}<left>", opts)
vim.api.nvim_set_keymap('i', '<u', "\\underline{}<left>", opts)
vim.api.nvim_set_keymap('i', '<b', "\\textbf{}<left>", opts)
vim.api.nvim_set_keymap('i', '<c', "~\\cite{}<left>", opts)
vim.api.nvim_set_keymap('i', '<r', "~\\ref{}<left>", opts)
vim.api.nvim_set_keymap('i', '<f', "\\footnote{\\url{}}<left><left>", opts)

vim.api.nvim_set_keymap('n', '<C-s>', ":update <bar> !sh bin/compile<CR><CR>", opts)
vim.api.nvim_set_keymap('n', '<C-S-s>', ":update <bar> !sh compile<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>.', "f.lxi<CR><ESC>", opts)
