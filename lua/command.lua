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

local function plugin_cmd(opts)
  local args = opts.args
  vim.cmd('!python3 ~/.config/nvim/plugin_manager.py ' .. args)
end

vim.api.nvim_create_user_command(
  'Plugins',
  -- Call external python script to update plugins
  plugin_cmd,
  { nargs = '*' }
)
