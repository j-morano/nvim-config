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

map('i', '<M-l>', '<Plug>(copilot-next)', {})
map('i', '<M-ñ>', '<Plug>(copilot-previous)', {})
map("i", "<M-p>", 'copilot#Accept("<CR>")', opts)
map('i', '<M-o>', accept_word, opts)
map('i', '<M-i>', accept_line, opts)

vim.g.copilot_filetypes = {markdown = true}
