
local opts = {noremap = true}
local map = vim.keymap.set

map('n', '<leader>cc', function()
  require("zen-mode").toggle({
    window = {
      width = 0.7 -- width will be 85% of the editor width
    }
  })
end, opts)
