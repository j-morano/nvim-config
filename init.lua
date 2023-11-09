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
end
