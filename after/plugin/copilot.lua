local map = vim.keymap.set


local function accept_words(n)
  vim.fn['copilot#Accept']("")  -- Accept the suggestion
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  local words = vim.fn.split(bar, [[[ .]\zs]])  -- Split by space or dot
  local result = table.concat(vim.list_slice(words, 1, n), "")
  return result
end


local function accept_line()
  vim.fn['copilot#Accept']("")
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar, [[[\n]\zs]])[1]
end

local opts = { remap = false, silent = true, expr = true, replace_keycodes = false }

map('i', '<M-m>', '<Plug>(copilot-next)', {})
map("i", "<M-p>", 'copilot#Accept("<CR>")', opts)
map('i', '<M-o>', function() return accept_words(1) end, opts)
map('i', '<M-i>', accept_line, opts)
map('i', '<M-u>', function() return accept_words(4) end, opts)

-- Activate copilot all filetypes
vim.g.copilot_filetypes = {
  markdown = true
}

-- Disabled by default
-- vim.g.copilot_enabled = 0
