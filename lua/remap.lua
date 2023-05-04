local map = vim.keymap.set
local opts = {noremap = true}--, silent = true}


-- Center text
map("n", "<leader>cc", function()
  local signcolumn = vim.wo.signcolumn
  local foldcolumn = vim.wo.foldcolumn
  if signcolumn == 'yes:9' and foldcolumn == '9' then
    vim.cmd('bufdo set foldcolumn=0')
    vim.cmd('bufdo set signcolumn=yes:2')
  else
    vim.cmd('bufdo set foldcolumn=9')
    vim.cmd('bufdo set signcolumn=yes:9')
  end
end, opts)


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
-- Terminal
map('t', '<M-x>', '<C-\\><C-n>', opts)
map('t', '<M-w>', '<C-\\><C-n>:e#<CR>', opts)
-- Panes
map('t', '<M-q>', '<C-\\><C-n>:wincmd p<CR>', opts)
-- Run current file
map('n', '<M-r>', ':!"%:p"<CR>', opts)
-- Folding and indent blankline
map('n', 'zo', 'zo:IndentBlanklineRefresh<CR>', opts)
map('n', 'zc', 'zc:IndentBlanklineRefresh<CR>', opts)
map('n', 'zR', 'zR:IndentBlanklineRefresh<CR>', opts)

local expr_opts = {noremap = true, expr = true}
-- Move cursor by display lines
-- Jump regular lines when using numbers
map('n', 'j', "v:count ? 'j' : 'gj'", expr_opts)
map('n', 'k', "v:count ? 'k' : 'gk'", expr_opts)
map('v', 'j', "v:count ? 'j' : 'gj'", expr_opts)
map('v', 'k', "v:count ? 'k' : 'gk'", expr_opts)

local expr_opts_silent = {noremap = true, expr = true, silent = true}
-- Always use global marks
map('n', "'",  '"`" . toupper(nr2char(getchar())) . "zz"', expr_opts_silent)
map('n', "m", '"m" . toupper(nr2char(getchar()))', expr_opts_silent)


local function search_on_current_line_only(str)
  -- Get position of the cursor after the search. If it is in the same line,
  -- return it. Otherwise, return the cursor to the original position and
  -- return 0.
  local r_o,c_o = unpack(vim.api.nvim_win_get_cursor(0))
  local r_s = vim.fn.search(str, 'c')
  if r_o == r_s then
    return r_s
  else
    vim.api.nvim_win_set_cursor(0, {r_o,c_o})
    return 0
  end
end


local function rewrap()
  -- Search a '(' in the current line
  -- If found, add a carriage return after it
  -- If not found, search for ', ', remove the space and put a carriage return
  -- after the comma.
  -- If not found, search for ')' and put a carriage return before it.
  -- If not found, return.

  -- Search for '(' only in the current line
  local pos = search_on_current_line_only('(')
  -- Insert carriage return using feedkeys, and exit insert mode
  local init_par_keys = vim.api.nvim_replace_termcodes('a<CR><ESC>',true,false,true)
  local comma_keys = vim.api.nvim_replace_termcodes('lxi<CR><ESC>',true,false,true)
  local fin_par_keys = vim.api.nvim_replace_termcodes('i<CR><ESC>2l',true,false,true)
  -- Apply only if the search was successful in the current line
  if pos ~= 0 then
    vim.api.nvim_feedkeys(init_par_keys, 'n', false)
    return
  end
  pos = search_on_current_line_only(', ')
  if pos ~= 0 then
    vim.api.nvim_feedkeys(comma_keys, 'n', false)
    return
  end
  pos = search_on_current_line_only(')')
  if pos ~= 0 then
    vim.api.nvim_feedkeys(fin_par_keys, 'n', false)
    return
  end
end

map('n', '<leader>,', rewrap, opts)
