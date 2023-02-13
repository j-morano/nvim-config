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
