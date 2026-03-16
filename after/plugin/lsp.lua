-- Global defaults for all servers
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Single on_attach via autocmd instead of per-server function
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local bufopts = { noremap = true, silent = true, buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover { border = "single", max_height = 25, max_width = 120 }
    end, bufopts)
    vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
  end,
})

-- Diagnostic keymaps
vim.keymap.set(
  'n', '<space>e',
  vim.diagnostic.open_float, { noremap = true, silent = true }
)
vim.keymap.set(
  'n', '<space>q',
  vim.diagnostic.setloclist, { noremap = true, silent = true }
)
vim.keymap.set(
  'n', '<M-e>',
  vim.diagnostic.open_float, {}
)

-- Server-specific config (only what differs from the global defaults)
vim.lsp.config.ty = {
  settings = {
    ty = {
      inlayHints = {
        callArgumentNames = false,
        variableTypes = false,
        functionReturnTypes = false,
        enumMemberValues = false,
        parameterNames = false,
      }
    }
  }
}

local clangd_caps = require('blink.cmp').get_lsp_capabilities()
clangd_caps.offsetEncoding = { "utf-16" }
vim.lsp.config.clangd = {
  cmd = { "clangd" },
  capabilities = clangd_caps,
}

vim.lsp.config.lua_ls = {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

vim.lsp.enable({ "ty", "ruff", "texlab", "clangd", "lua_ls" })
vim.lsp.inlay_hint.enable(true)
