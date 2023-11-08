local map = vim.keymap.set
local opts = {noremap = true}--, silent = true}


-- VIM
map('n', 's', function() vim.cmd('update') end, opts)
-- Save on exit insert mode
--autocmd InsertLeave * update
-- Best remap ever
--  Replace currently selected text with default register
--  without yanking it
map('v', 'p', 'pgvy', opts)
map('', 'c', '"_c', opts)
map('v', 'P', 'pgvy', opts)
-- Add blank line below
map('n', '_', 'o<Esc>k', opts)
-- More comfortable keybindig for alternate-file
map('i', '<M-w>', '<ESC>:e#<CR>a', opts)
map('n', '<M-w>', ':e#<CR>', opts)
map('i', '<M-q>', '<ESC>:wincmd p<CR>a', opts)
map('n', '<M-q>', ':wincmd p<CR>', opts)
-- Alternative escape
map('i', 'jk', '<ESC>', opts)
map('i', 'kj', '<ESC>', opts)
-- Yank a region without moving the cursor to the top of the block
map('v', 'y', 'ygv<Esc>', opts)
-- Remap increase number
map('n', '<C-c>', '<C-a>', opts)
-- Move cursor in insert mode
map('i', '<C-l>', '<Right>', opts)
map('i', '<C-ñ>', '<Left>', opts)
-- wezterm (see [1]):
map('i', '<C-;>', '<Left>', opts)
-- Avoid unintentionally macro recording
map('n', 'q', '<Nop>', opts)
map('n', 'qq', 'q', opts)
-- Go to last change
map('n', 'H', 'g;', opts)
--- Best remaps ever ---
-- Behave Vim
map('n', 'Y', 'yg$', opts)
--" Keeping it centered
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)
map('n', 'J', 'mzJ`z', opts)
-- Moving text
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)
-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
--  so that you can undo CTRL-U after inserting a line break.
--  Revert with ":iunmap <C-U>".
map('i', '<C-U>', '<C-G>u<C-U>', opts)
-- Delete with ctrl-backspace
map('i', '<C-BS>', '<C-w>', opts)
-- [1] Sometimes, wezterm interprets keybindings in a weird way, so it is
-- necessary to define other custom keybindings:
map('i', '<C-H>', '<C-w>', opts)
-- Custom hjkl remap
map('', 'ñ', 'h', opts)
map({'n', 'v'}, 'Ñ', ':', opts)
-- wezterm (see [1]):
map({'n', 'v'}, '<S-Ñ>', ':', opts)
map('n', 'qÑ', 'q:', opts)
map('n', '@Ñ', '@:', opts)
map('n', '<C-w>ñ', '<C-w>h', opts)
-- Ex
map('n', '<M-e>', '<cmd>Ex<CR>', opts)
-- Alternative return to to avoid select suggestion
map('i', '<M-CR>', '<CR>', opts)
-- Filename suggestions
map('i', '<C-f>', '<C-x><C-f>', opts)
-- Auto-expansion
map('i', '(<CR>', '(<CR>)<C-c>O', opts)
map('i', '{<CR>', '{<CR>}<C-c>O', opts)
map('i', '[<CR>', '[<CR>]<C-c>O', opts)
map('i', '(<Space>', '()<Left>', opts)
map('i', '{<Space>', '{}<Left>', opts)
map('i', '[<Space>', '[]<Left>', opts)
map('i', '\'<Space>', '\'\'<Left>', opts)
map('i', '"<Space>', '""<Left>', opts)
-- Run current file
map('n', '<M-r>', ':!"%:p"<CR>', opts)
-- Folding and indent blankline
map('n', 'zo', 'zo:IndentBlanklineRefresh<CR>', opts)
map('n', 'zc', 'zc:IndentBlanklineRefresh<CR>', opts)
map('n', 'zR', 'zR:IndentBlanklineRefresh<CR>', opts)

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

local ts_utils = require("nvim-treesitter.ts_utils")
local ts_vim = require("vim.treesitter")

-- Function to get argument_list and put each argument in a new line. The cursor
-- position must be the initial parenthesis.
local function wrap_args()
  -- Get column of cursor
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local node_at_cursor = ts_utils.get_node_at_cursor()
  local args = ts_utils.get_named_children(node_at_cursor)
  -- Remove the rest of the line after the cursor
  local args_text = {}
  for _, arg in ipairs(args) do
    local arg_text = ts_vim.get_node_text(arg, 0)
    table.insert(args_text, arg_text)
  end
  -- Get text after the end of the node_at_cursor
  local line = vim.api.nvim_get_current_line()
  if not node_at_cursor then
    return
  end
  local node_length = ts_utils.node_length(node_at_cursor)
  -- get text after node_length
  local text = string.sub(line, col + node_length)
  vim.cmd("normal! l\"_d$")
  local num_args = #args_text
  local i = 1
  for _, arg in ipairs(args_text) do
    -- if last element, don't add comma
    if i == num_args then
      vim.cmd("normal! o" .. arg)
    else
      vim.cmd("normal! o" .. arg .. ",")
    end
    i = i + 1
  end
  vim.cmd("normal! o" .. text)
end

map('n', '<M-a>', wrap_args, opts)


-- Wildmenu
vim.cmd([[
cnoremap <expr> <CR> wildmenumode() ? "<space>\<bs>\<C-Z>" : "\<CR>"
cnoremap <expr> <C-p> wildmenumode() ? "\<up>" : "\<C-p>"
]])


---- Terminal
map('t', '<M-x>', '<C-\\><C-n>', opts)
map('t', '<M-w>', '<C-\\><C-n>:e#<CR>', opts)


---- Panes
map({'t', 'n'}, '<M-h>', function ()
  vim.cmd('wincmd w')
end, opts)


---- Vim-style alternative to multiple cursors

local function get_visual_selection()
    -- Yank current visual selection into the 'v' register
    -- Note that this makes no effort to preserve this register
    vim.cmd('noau normal! "vy"')
    return vim.fn.getreg('v')
end


local function escape_string(string)
  local escape_characters = {
    '\\', '"', "'", '[', ']', '.', '*', '+', '-', '?', '^', '$', '(', ')', '%',
    '#', '{', '}', '|', '<', '>', '=', '!', ':'
  }
  for _, char in ipairs(escape_characters) do
    string = vim.fn.escape(string, char)
  end
  return string
end

-- Apply macro to given word
local function apply_macro()
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'v' then
    local selection = get_visual_selection()
    local escaped_selection = escape_string(selection)
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
