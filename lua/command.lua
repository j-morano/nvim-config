-- Remove trailing spaces
vim.api.nvim_create_user_command(
  'RmTrail',
  function() vim.cmd('%s/\\s\\+$//e') end,
  {}
)

-- Close buffer without closing window
vim.api.nvim_create_user_command(
  'BD',
  function() vim.cmd('bp | sp | bn | bd') end,
  {}
)

-- Close buffer without closing window
vim.api.nvim_create_user_command(
  'CH',
  function() vim.cmd('!chmod +x %') end,
  {}
)

---- Plugins

vim.api.nvim_create_user_command(
  'Plugins',
  -- Call external python script to update plugins
  function()
    vim.ui.input({ prompt = 'option: ' }, function(input)
      vim.cmd('!python3 ~/.config/nvim/scripts/plugins.py ' .. input)
    end)
  end,
  {}
)
