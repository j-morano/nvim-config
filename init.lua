require('colorscheme')
require('set')
require('remap')
require('autocmd')
require('command')


-- Lecture mode
function Lec()
  vim.diagnostic.config({ virtual_text = false })
  vim.cmd('Copilot disable')
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { fg = "#ff0000", underline = true })
  vim.api.nvim_set_hl(0, "Comment", { fg = "#797fa3" })
end


-- Disable lspconfig warning for now
-- local notify = vim.notify
-- vim.notify = function(msg, level, opts)
--   if type(msg) == "string" and msg:match("The `require%('lspconfig'%)` \"framework\" is deprecated") then
--     return
--   end
--   notify(msg, level, opts)
-- end
