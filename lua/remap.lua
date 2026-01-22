local map = vim.keymap.set
local opts = {noremap = true}--, silent = true}


-- VIM
map('n', 's', function() vim.cmd('update') end, opts)
-- Best remap ever
--  Replace currently selected text with default register
--  without yanking it
map('v', 'p', 'pgvy', opts)
map('', 'c', '"_c', opts)
-- Copy current word
map('n', 'h', 'viw', opts)
-- Add blank line below, but keep cursor in the same position
-- Use a function that checks for the Quickfix window
map('n', '<Enter>', function()
  -- 1. Check if we are in a Quickfix window
  if vim.bo.buftype == 'quickfix' then
    -- Close the Quickfix window when selecting an entry
    vim.schedule(function()
      vim.cmd('cclose')
    end)
    -- We return the actual carriage return key to trigger the jump
    return '<CR>'
  end
  -- 2. If modifiable, schedule the line insertion
  if vim.bo.modifiable then
    local pos = vim.fn.getpos('.')
    vim.schedule(function()
      -- We use the API to avoid "normal!" command restrictions
      vim.api.nvim_put({''}, 'l', true, false)
      vim.fn.setpos('.', pos)
    end)
  end
  -- 3. Return nothing so Enter doesn't move the cursor down in normal buffers
  return '<Ignore>'
end, { expr = true, silent = true })
-- More comfortable keybindig for alternate-file
map('i', '<M-w>', '<ESC>:e#<CR>a', opts)
map('n', '<M-w>', ':e#<CR>', opts)
-- Move cursor in insert mode
map('i', '<M-l>', '<Right>', opts)
map('i', '<M-;>', '<Left>', opts)  -- ";" : wezterm
-- Better jumping
map('', '<M-j>', '<C-d>zz', opts)
map('', '<M-k>', '<C-u>zz', opts)
-- Avoid unintentionally macro recording
map('n', 'q', '<Nop>', opts)
map('n', 'qq', 'q', opts)
-- Go to last change and next change
map('n', '<Tab>', 'g;', opts)
map('n', '<M-Tab>', 'g,', opts)
-- Behave Vim
map('n', 'Y', 'yg$', opts)
-- Yank selection and keep cursor in place
map('v', 'y', 'ygv<Esc>', opts)
--" Keeping it centered
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)
map('n', 'J', 'mzJ`z', opts)
-- Go to mark
map('n', '<M-m>', '`', opts)
-- Moving text
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)
-- Custom hjkl remap
map('', 'ñ', 'h', opts)
map({'n', 'v'}, 'Ñ', ':', opts)
map('n', ';', 'h', opts)
-- wezterm (see [1]):
map({'n', 'v', 'i'}, '<S-Ñ>', ':', opts)
map('n', '<C-w>ñ', '<C-w>h', opts)
-- Filename suggestions
map('i', '<C-f>', '<C-x><C-f>', opts)
-- Auto-expansion
-- map('i', '(<CR>', '(<CR>)<C-c>O', opts)
-- map('i', '{<CR>', '{<CR>}<C-c>O', opts)
-- map('i', '[<CR>', '[<CR>]<C-c>O', opts)
-- map('i', '(<Space>', '()<Left>', opts)
-- map('i', '{<Space>', '{}<Left>', opts)
-- map('i', '[<Space>', '[]<Left>', opts)
-- map('i', '\'<Space>', '\'\'<Left>', opts)
-- map('i', '"<Space>', '""<Left>', opts)
-- Run current file
map('n', '<M-r>', ':!"%:p"<CR>', opts)
-- Deactivate C-v for visual block
map('n', '<C-v>', '<Nop>', opts)
map('n', 'vv', '<C-v>', opts)
-- Alternative escape
map('i', 'jj', '<ESC>', opts)
-- Move to pane
map('n', '<M-h>', '<C-w><C-w>', opts)
-- Smart dd: only yank the lines if the current line is not empty
map('n', 'dd', function()
  local count = vim.v.count1
  if vim.fn.getline('.') == '' then
    vim.cmd('normal! "_' .. count .. 'dd')
  else
    vim.cmd('normal! ' .. count  .. 'dd')
  end
end, opts)
-- Repeat or execute macro on all visually selected lines.
map('x', '.', ':norm .<CR>', opts)
map('x', '@', ':norm @q<CR>', opts)


-- Search
local function do_hlsearch()
  vim.opt.hlsearch = true
  -- Put the word under the cursor in the search register
  vim.cmd('let @/ = expand("<cword>")')
end

local function undo_hlsearch()
  vim.opt.hlsearch = false
  -- [Optional] Clear search register and s register
  -- vim.cmd('let @/=""')
end
map('n', '+', do_hlsearch, opts)
map('n', '<Esc>', undo_hlsearch, opts)

local expr_opts = {noremap = true, expr = true}
-- Move cursor by display lines
-- Jump regular lines when using numbers
map('n', 'j', "v:count ? 'j' : 'gj'", expr_opts)
map('n', 'k', "v:count ? 'k' : 'gk'", expr_opts)
map('v', 'j', "v:count ? 'j' : 'gj'", expr_opts)
map('v', 'k', "v:count ? 'k' : 'gk'", expr_opts)


---- Useful formatting mappings

local function wrap_args()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_orig = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_orig[1] - 1, cursor_orig[2]

  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    print("No parser found for this buffer")
    return
  end
  local tree = parser:parse()[1]

  local root = tree:root()
  local node = root:named_descendant_for_range(row, col, row, col)

  if not node then return end

  local target_types = {
    argument_list = true, parameters = true, list = true,
    dictionary = true, table_constructor = true
  }

  while node and not target_types[node:type()] do
    node = node:parent()
  end

  if not node then return end

  local args = {}
  for child in node:iter_children() do
    if child:named() then
      table.insert(args, vim.treesitter.get_node_text(child, bufnr))
    end
  end

  local s_row, s_col, e_row, e_col = node:range()
  local text = vim.api.nvim_buf_get_text(bufnr, s_row, s_col, e_row, e_col, {})
  local opening = string.sub(text[1], 1, 1)
  local closing = string.sub(text[#text], #text[#text], #text[#text])

  local new_lines = { opening }
  for i, arg in ipairs(args) do
    table.insert(new_lines, "  " .. arg .. ",")
  end
  table.insert(new_lines, closing)

  -- Apply the change
  vim.api.nvim_buf_set_text(bufnr, s_row, s_col, e_row, e_col, new_lines)

  -- 1. Correct Indentation
  local last_row = s_row + #new_lines - 1
  vim.cmd(string.format("silent! normal! %dG=%dG", s_row + 1, last_row + 1))

  -- 2. Smart Cursor Restoration
  -- We move the cursor to the first argument line (s_row + 1)
  -- and put it at the first non-blank character
  vim.api.nvim_win_set_cursor(0, cursor_orig)
end

vim.keymap.set('n', '<M-a>', wrap_args, { desc = "TS: Wrap arguments" })


---- Terminal
map('t', '<M-x>', '<C-\\><C-n>', opts)
map('t', '<M-w>', '<C-\\><C-n>:e#<CR>', opts)


---- Interactive python

local utils = require('utils')


-- map('t', '<M-q>', '<C-\\><C-n>:wincmd p<CR>', opts)
-- Open interactive python in terminal (right pane)
local function open_interactive_python()
  vim.cmd('term ipython')
end
map('n', '<M-S-p>', open_interactive_python, opts)


-- Easily jump between the interactive python terminal and the code
local function jump_to_terminal_buffer()
  local terminal_buffer = vim.fn.bufnr('ipython')
  if terminal_buffer == -1 then
    return 1
  end
  vim.cmd('buffer ' .. terminal_buffer)
  return 0
end


local function jump_and_run()
  -- Jump to the interactive python terminal and run visual selection
  utils.get_visual_selection()
  if jump_to_terminal_buffer() == 1 then
    return
  end
  -- paste the visual selection
  vim.cmd[[normal! "vp]]
  -- emulate pressing enter inside the terminal using feedkeys
  local enter = vim.api.nvim_replace_termcodes('<CR>', true, false, true)
  vim.api.nvim_feedkeys(enter, 't', false)
end
map({'v'}, '<M-p>', jump_and_run, opts)




---- Vim-style alternative to multiple cursors


-- Apply macro to given word
local function apply_macro()
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'v' then
    local selection = utils.get_visual_selection()
    local escaped_selection = utils.escape_string(selection)
    vim.fn.setreg('/', escaped_selection)
  elseif mode == 'n' then
    -- Move cursor to the beginning of the word under the cursor and yank it
    vim.cmd('normal! "vyiw')
    local word = vim.fn.getreg('v')
    vim.fn.setreg('/', word)
  end
  -- start recording macro
  vim.cmd('normal! qi')
end

local function record_macro()
  local mode = vim.api.nvim_get_mode().mode
  -- exit insert mode if it is being recorded
  if mode == 'i' then
    vim.cmd('stopinsert')
  -- exit visual mode if it is being recorded
  elseif mode == 'v' then
    -- feedkeys
    local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'x', false)
  end
  -- stop recording macro if it is being recorded
  -- or do nothing if it is not
  vim.cmd('normal! qq')
end

map({'n', 'v'}, 'qi', apply_macro, opts)
map('n', '<M-s>', 'n@i', opts)
map({'i', 'v', 'n'}, '<M-q>', record_macro, opts)
