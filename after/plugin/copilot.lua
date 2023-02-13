local map = vim.keymap.set

local function SuggestOneWord()
  vim.fn['copilot#Accept']("")
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar,  [[[ .]\zs]])[1]
end
map('i', '<M-j>', '<Plug>(copilot-next)')
map('i', '<M-k>', '<Plug>(copilot-previous)')
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<M-i>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
map('i', '<M-o>', SuggestOneWord, {expr = true, remap = false})
