local map = vim.keymap.set

local function accept_word()
  vim.fn['copilot#Accept']("")
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar, [[[ .]\zs]])[1]
end

local function accept_line()
  vim.fn['copilot#Accept']("")
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar, [[[\n]\zs]])[1]
end

local opts = { remap = false, silent = true, expr = true, replace_keycodes = false }

map('i', '<M-m>', '<Plug>(copilot-next)', {})
map("i", "<M-p>", 'copilot#Accept("<CR>")', opts)
map('i', '<M-o>', accept_word, opts)
map('i', '<M-i>', accept_line, opts)

-- Activate copilot all filetypes
vim.g.copilot_filetypes = {
  markdown = true
}

-- Disabled by default
-- vim.g.copilot_enabled = 0
