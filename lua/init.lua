---- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  ['<TAB>'] = cmp.mapping.select_next_item(),
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  -- { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
  { name = 'nvim_lsp_signature_help' },
  { name = 'path' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())


---- LSP

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require'lspconfig'.pylsp.setup({
    cmd={"python3", "-m", "pylsp"},
    settings = {
        pylsp = {
            plugins={
                pycodestyle={
                    enabled=false
                }
            }
        }
    },
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
})
require'lspconfig'.texlab.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
})
require'lspconfig'.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
})

require('rust-tools').setup({
    tools = {
        inlay_hints = {
            highlight = "LspDiagnosticsDefaultHint"
        }
    }
})
require "lsp_signature".setup({
    floating_window = false,
})


---- VIM options

-- Show @@@ in the last line if it is truncated.
vim.opt.display = 'truncate'
-- Show a few lines of context around the cursor. Note that this makes the
--  text scroll if you mouse-click near the start or end of the window.
vim.opt.scrolloff = 0
-- Time out for key codes
vim.opt.ttimeout = true
-- Wait up to 100ms after Esc for special key
vim.opt.ttimeoutlen = 100
-- Keep 200 lines of command line history
vim.opt.history = 200
-- Show the cursor position all the time
vim.opt.ruler = true
-- Display incomplete commands
vim.opt.showcmd = true
-- Display completion matches in status line
vim.opt.wildmenu = true
-- Show relative numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- Always show 2 sign columns
vim.opt.signcolumn = 'yes'
-- Status line
vim.opt.laststatus = 2
-- Switch buffer even if it is not saved
vim.opt.hidden = true
-- Allow backspacing over everything in insert mode.
vim.opt.backspace = 'indent,eol,start'
-- Encoding
vim.opt.encoding = 'utf-8'
-- Ignore case in searches.
vim.opt.ignorecase = true
-- Override the 'ignorecase' option if the search pattern contains upper
--  case characters. Only used when the search pattern is typed and
--  'ignorecase' option is on.
vim.opt.smartcase = true
-- Open splits to the right and below
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Wildmode to last used
vim.opt.wildmode = 'full:lastused'
-- Break indent
vim.opt.breakindent = true
vim.opt.showbreak = '>>'
-- Soft word wrap
vim.opt.wrap = true
vim.opt.linebreak = true
-- Show tabline
vim.opt.showtabline = 1

---- VIM global variables
vim.g['cursorword_highlight'] = 0
vim.g['cursorword_delay'] = 0
-- Map leader to space
vim.g['mapleader'] = ' '

local map = vim.keymap.set
local opts = {noremap = true, silent = true}

-- Telescope keybindings
local telescope = require('telescope.builtin')
map('n', '<leader>ff', telescope.find_files, opts)
map('n', '<leader>fg', telescope.live_grep, opts)
map('n', '<leader>fh', telescope.help_tags, opts)
map('n', '<leader>fb', telescope.buffers, opts)
map('n', '<leader>fr', telescope.resume, opts)

-- Harpoon keybindings
local harpoon_ui = require('harpoon.ui')
local harpoon_mark = require('harpoon.mark')
map('n', '<leader>o', harpoon_ui.toggle_quick_menu, opts)
map('n', '<leader>a', harpoon_mark.add_file, opts)
map('n', '<leader>j', harpoon_ui.nav_next, opts)
map('n', '<leader>k', harpoon_ui.nav_prev, opts)
map('n', '<leader>1', function() harpoon_ui.nav_file(1) end, opts)
map('n', '<leader>2', function() harpoon_ui.nav_file(2) end, opts)
map('n', '<leader>3', function() harpoon_ui.nav_file(3) end, opts)
map('n', '<leader>4', function() harpoon_ui.nav_file(4) end, opts)
