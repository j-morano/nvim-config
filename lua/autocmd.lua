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

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.api.nvim_create_autocmd(
  'BufReadPost',
  {
    pattern = '*',
    callback = function()
      local row, col = unpack(vim.api.nvim_buf_get_mark(0, "\""))
      if {row, col} ~= {0, 0} then
        vim.api.nvim_win_set_cursor(0, {row, col})
      end
    end,
  }
)


-- When switching buffers, preserve window view.
--au BufLeave * if !&diff | let b:winview = winsaveview() | endif
--au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | endif

vim.api.nvim_create_autocmd(
  'BufLeave',
  {
    pattern = '*',
    callback = function()
      if not vim.w.diff then
        vim.b.winview = vim.fn.winsaveview()
      end
    end,
  }
)

vim.api.nvim_create_autocmd(
  'BufEnter',
  {
    pattern = '*',
    callback = function()
      if vim.b.winview and not vim.w.diff then
        vim.fn.winrestview(vim.b.winview)
      end
    end,
  }
)

vim.api.nvim_create_autocmd({"BufWinLeave"}, {
  pattern = {"*.*"},
  desc = "save view (folds), when closing file",
  command = "mkview",
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {"*.*"},
  desc = "load view (folds), when opening file",
  command = "silent! loadview"
})
