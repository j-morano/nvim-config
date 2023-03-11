local function set_color_columns(columns)
  return function ()
    vim.opt.colorcolumn = columns
  end
end

-- Vertical rulers
vim.opt.colorcolumn = {81}
vim.api.nvim_create_autocmd(
    { "FileType" },
    {
      pattern = "python",
      callback = set_color_columns({73, 80})
    }
)
vim.api.nvim_create_autocmd(
    { "FileType" },
    {
      pattern = "rust",
      callback = set_color_columns({81, 101})
    }
)
-- Custom tabspaces values
vim.api.nvim_create_autocmd(
    { "FileType" },
    {
      pattern = {"javascript", "typescript", "lua", "html", "css" },
      command = "setlocal ts=2 sts=2 sw=2 expandtab"
    }
)
-- Resize Neovim itself when launched as initial command for terminal
vim.api.nvim_create_autocmd(
  { 'VimEnter' },
  {
    pattern = '*',
    callback = function()
      vim.cmd('sleep 100m')
      vim.cmd('silent exec "!kill -s SIGWINCH" getpid()')
    end
  }
)

-- Terminal
-- Start directly in insert mode
vim.api.nvim_create_autocmd(
  { 'TermOpen' },
  {
    pattern = 'term://*',
    callback = function()
      vim.cmd('startinsert')
      vim.cmd('setlocal nonumber norelativenumber')
    end
  }
)
vim.api.nvim_create_autocmd(
  { 'BufEnter' },
  { pattern = 'term://*', command = 'startinsert' }
)
vim.api.nvim_create_autocmd(
  { 'BufLeave' },
  { pattern = 'term://*', command = 'stopinsert' }
)
