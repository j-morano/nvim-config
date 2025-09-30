-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)


local function functionify(fn)
  return function()
    return fn()
  end
end


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', functionify(vim.lsp.buf.declaration), bufopts)
  vim.keymap.set('n', 'gd', functionify(vim.lsp.buf.definition), bufopts)
  vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover { border = "single", max_height = 25, max_width = 120 }
  end, bufopts)
  vim.keymap.set('n', 'gI', functionify(vim.lsp.buf.implementation), bufopts)
  vim.keymap.set('n', '<C-k>', functionify(vim.lsp.buf.signature_help), bufopts)
  vim.keymap.set('i', '<C-k>', functionify(vim.lsp.buf.signature_help), bufopts)
  vim.keymap.set('n', '<space>wa', functionify(vim.lsp.buf.add_workspace_folder), bufopts)
  vim.keymap.set('n', '<space>wr', functionify(vim.lsp.buf.remove_workspace_folder), bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', functionify(vim.lsp.buf.type_definition), bufopts)
  vim.keymap.set('n', '<space>rn', functionify(vim.lsp.buf.rename), bufopts)
  vim.keymap.set('n', '<space>ca', functionify(vim.lsp.buf.code_action), bufopts)
  vim.keymap.set('n', 'gr', functionify(vim.lsp.buf.references), bufopts)
  vim.keymap.set('n', '<space>f', functionify(vim.lsp.buf.formatting), bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


vim.lsp.config.pyright = {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}

vim.lsp.config.texlab = {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}


local clangd_capabilities = capabilities
clangd_capabilities.offsetEncoding = { "utf-16" }

vim.lsp.config.clangd = {
  cmd = { "clangd" },
  capabilities = clangd_capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}

vim.lsp.config.lua_ls = {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        -- Do not ask about working environment on every startup
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}


require "lsp_signature".setup({
  floating_window = false,
  doc_lines = 1,
  hint_prefix = "📚 ",
})
vim.keymap.set({ 'i' }, '<M-k>', function()
  vim.lsp.buf.signature_help()
end,
{ silent = true, noremap = true, desc = 'toggle signature' })


vim.keymap.set('n', '<M-d>', vim.diagnostic.open_float, {})

vim.lsp.enable({ "pyright", "texlab", "clangd", "lua_ls" })

-- Disable virtual text with inlay/type hints
vim.lsp.inlay_hint.enable(true)
