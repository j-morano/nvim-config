-- module
local M = {}

function M.escape_string(string)
  local escape_characters = {
    '\\', '"', "'", '[', ']', '.', '*', '+', '-', '?', '^', '$', '(', ')', '%',
    '#', '{', '}', '|', '<', '>', '=', '!', ':'
  }
  for _, char in ipairs(escape_characters) do
    string = vim.fn.escape(string, char)
  end
  return string
end


function M.get_visual_selection()
  -- Yank current visual selection into the 'v' register
  -- Note that this makes no effort to preserve this register
  vim.cmd('noau normal! "vy"')
  return vim.fn.getreg('v')
end


-- export
return M
