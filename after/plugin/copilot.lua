local map = vim.keymap.set

local function accept_word()
  vim.fn['copilot#Accept']("")
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar,  [[[ .]\zs]])[1]
end

vim.g.copilot_no_tab_map = true

map('i', '<M-j>', '<Plug>(copilot-next)', {})
map('i', '<M-k>', '<Plug>(copilot-previous)', {})
map(
  "i", "<M-i>", 'copilot#Accept("<CR>")',
  { silent = true, expr = true }
)
map('i', '<M-o>', accept_word, {expr = true, remap = false})
