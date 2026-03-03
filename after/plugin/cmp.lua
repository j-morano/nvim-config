---- Setup nvim-cmp.

require('blink.cmp').setup({
  -- 1. Snippets: 1:1 Luasnip integration
  -- snippets = { preset = 'luasnip' },
  snippets = { preset = 'default' },

  -- 2. Keymaps: Migration of your <TAB> and <C-space> logic
  keymap = {
    preset = 'none', -- We'll define your exact mappings from the old config
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide' },
    ['<CR>'] = { 'accept', 'fallback' },

    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },

    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
  },

  -- 3. Sources: Replacing your cmp.config.sources
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },

    -- Filetype specific overrides (Replacing your setup.filetype logic)
    per_filetype = {
      gitcommit = { 'buffer' }, -- Note: 'cmp_git' would need blink.compat if desired
      tex = { 'lsp', 'snippets', 'buffer' },
    },
  },

  -- 4. Window: Bordered windows if you prefer them
  completion = {
    menu = { border = 'rounded' },
    documentation = { window = { border = 'rounded' }, auto_show = true },
  },

  -- Experimental (but very 2026) signature help
  signature = { enabled = true }
})

