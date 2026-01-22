local opts = {noremap = true}
local map = vim.keymap.set
local bm = require("buffer_manager")
---- Setup
bm.setup({
  select_menu_item_commands = {
    v = {
      key = "<M-v>",
      command = "vsplit"
    },
    h = {
      key = "<M-h>",
      command = "split"
    }
  },
  focus_alternate_buffer = false,
  short_file_names = false,
  short_term_names = true,
  loop_nav = true,
  -- order_buffers = 'lastused',
  -- use_shortcuts = true,
})
---- Navigate buffers bypassing the menu
local bmui = require("buffer_manager.ui")
local keys = '1234567890'
for i = 1, #keys do
  local key = keys:sub(i,i)
  map(
    'n',
    string.format('<leader>%s', key),
    function () bmui.nav_file(i) end,
    opts
  )
end
---- Just the menu
map({ 't', 'n' }, '<M-Space>', bmui.toggle_quick_menu, opts)
---- Next/Prev
-- map('n', '<M-l>', bmui.nav_next, opts)
map('n', '<M-b>', bmui.nav_next, opts)
-- map('n', '<M-;>', bmui.nav_prev, opts)

---- Use <leader>-t to go to the terminal buffer

local function string_starts(string, start)
  return string.sub(string, 1, string.len(start)) == start
end

local function nav_term()
  -- Go to the first terminal buffer
  bmui.update_marks()
  for idx, mark in pairs(bm.marks) do
    if string_starts(mark.filename, "term://") then
      bmui.nav_file(idx)
      return
    end
  end
  -- If no terminal buffer is found, create a new one
  vim.cmd('terminal')
end

-- Map <leader>t to navigate to the first terminal buffer
map('n', '<leader>t', nav_term, opts)


-- Search in buffers

local function search_buffers()
  bmui.toggle_quick_menu()

  -- 1. Enter search mode immediately
  vim.api.nvim_feedkeys('/', 'n', false)

  -- 2. Create a temporary mapping for the Enter key
  --    This only applies to the current buffer (the menu)
  vim.keymap.set('c', '<CR>', function()
    -- If we are currently in a search ('/')
    if vim.fn.getcmdtype() == '/' then
      -- Finish the search AND immediately send a 'Select' Enter
      return '<CR><CR>'
    end
    return '<CR>'
  end, { remap = true, expr = true, buffer = true })
end

map('n', '<leader>s', search_buffers, opts)
