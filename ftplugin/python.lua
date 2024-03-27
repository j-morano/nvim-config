local opts = {noremap = true, silent = true}
-- Write dictionary keyworkds
vim.api.nvim_set_keymap('i', '<C-d>', "['']<left><left>", opts)
-- Run current file
vim.api.nvim_set_keymap('n', '<M-p>', ':!python3 "%:p"<CR>', opts)


local utils = require('utils')

---- Open Python documentation (pydoc) using C-k
local function open_pydoc()
  local selection = utils.get_visual_selection()
  local escaped_selection = utils.escape_string(selection)
  vim.cmd('term pydoc ' .. escaped_selection)
end

vim.keymap.set({'n', 'v'}, '<C-o>', open_pydoc, opts)


vim.api.nvim_create_user_command(
  'Pydoc',
  function(args)
    vim.cmd('term pydoc ' .. args.args)
  end,
  { nargs = '*' }
)

vim.api.nvim_create_autocmd(
    { "TermClose" },
    {
      pattern = "*",
      -- command = "execute 'bdelete! ' . expand('<abuf>')"
      callback = function()
        -- Check if the process is 'pydoc'
        -- If it is, delete the buffer
        local bufname = vim.fn.expand('<abuf>')
        if vim.fn.bufname(bufname):find('pydoc') then
          vim.cmd('bdelete')
        end
      end
    }
)
