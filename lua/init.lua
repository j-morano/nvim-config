---- Setup nvim-cmp.
local cmp = require'cmp'

assert(cmp, "cmp not found")

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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
    -- Accept currently selected item.
    --  Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<TAB>'] = cmp.mapping.select_next_item(),
    ['<S-TAB>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
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
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


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
local on_attach = function(_, bufnr)
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


local options = {
  tools = {
    autoSetHints = true,
    runnables = {
      use_telescope = true
    },
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
      highlight = "TypeHints",
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
  },
}

require('rust-tools').setup(options)

local clangd_capabilities = capabilities
clangd_capabilities.offsetEncoding = { "utf-16" }

require'lspconfig'.clangd.setup({
  cmd = { "clangd" },
  capabilities = clangd_capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
})

require'lspconfig'.sumneko_lua.setup {
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
})

require("indent_blankline").setup {
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
  },
}

require "telescope".setup {
  pickers = {
    buffers = {
      initial_mode = "normal"
    },
  }
}

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "lua", "rust", "vim" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


require("zen-mode").setup {
  window = {
    width = 120,
    options = {
      number = true,
      relativenumber = true,
    }
  },
}


---- VIM options

-- Show @@@ in the last line if it is truncated.
vim.opt.display = 'truncate'
-- Show a few lines of context around the cursor. Note that this makes the
--  text scroll if you mouse-click near the start or end of the window.
vim.opt.scrolloff = 8
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
-- Do not recognize octal numbers for Ctrl-x and Ctrl-c, it is
--  confusing.
vim.opt.nrformats:remove('octal')
-- Tabs as spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
-- Make the left and right arrow keys change line
vim.opt.whichwrap:append('<,>,[,],h,l')
-- Copy to system clipboard
--  Dependency: clipboard software. For example: xclip
vim.opt.clipboard:append('unnamedplus')
-- Do not highlight current word occurences
vim.opt.hlsearch = true
-- Incremental search
vim.opt.incsearch = true
-- Default updatetime 4000ms is not good for async update
vim.opt.updatetime = 100
-- Use mouse in normal, visual and insert mode
vim.opt.mouse = 'nvi'
-- Ignore case when completing file and directory names
vim.opt.ignorecase = true
-- Save marks and other information between sessions
vim.opt.viminfo = "'100,f1"
-- Maximum number of items to show in the popup menu
vim.opt.pumheight = 7
-- Show cursor line
vim.opt.cursorline = true
-- Use termguicolors
vim.opt.termguicolors = true
-- Permanent undo
vim.opt.undodir = vim.fn.expand('~/.undodir')
vim.opt.undofile = true
-- Do not highlight search matches
vim.opt.hlsearch = false


---- Window options
-- Custom highlights
vim.w.m1 = vim.fn.matchadd('Todo', 'TODO')
vim.w.m1 = vim.fn.matchadd('Todo', 'NOTE')
vim.w.m1 = vim.fn.matchadd('Todo', '···')


---- VIM global variables
vim.g['cursorword_highlight'] = 0
vim.g['cursorword_delay'] = 0
-- Map leader to space
vim.g['mapleader'] = ' '
-- Tex: solve excessive error highlighting
vim.g['tex_no_error'] = 1
-- Python syntax highlighting for Vim
vim.g['python_highlight_all'] = 1
---- Netrw
-- Do not move the cursor when returning to it
vim.g['netrw_fastbrowse'] = 2
-- Always show line numbers
vim.g['netrw_bufsettings'] = 'noma nomod rnu nobl nowrap ro'


---- Keybindings
local map = vim.keymap.set
opts = {noremap = true}--, silent = true}


map("n", "<leader>zz", function()
    require("zen-mode").toggle()
end, opts)

-- Telescope keybindings
local telescope = require('telescope.builtin')
map('n', '<leader>o', telescope.find_files, opts)
map('n', '<leader>fg', telescope.live_grep, opts)
map('n', '<leader>fh', telescope.help_tags, opts)
map('n', '<leader>fb', telescope.buffers, opts)
map('n', '<leader>fr', telescope.resume, opts)


-- buffer_manager
require("buffer_manager").setup({
  select_menu_item_commands = {
    v = {
      key = "<C-v>",
      command = "vsplit"
    },
    h = {
      key = "<C-h>",
      command = "split"
    }
  },
})
local bmui = require("buffer_manager.ui")
local keys = '1234567890'
for i = 1, #keys do
  local key = keys:sub(i,i)
  map(
    'n',
    string.format('<leader>%s', key),
    function () bmui.nav_file(i) end,
    opts
  )
end
map({ 't', 'n' }, '<M-Space>', bmui.toggle_quick_menu, opts)
map('n', '<M-j>', bmui.nav_next, opts)
map('n', '<M-k>', bmui.nav_prev, opts)

-- Copilot
local function SuggestOneWord()
  vim.fn['copilot#Accept']("")
  local bar = vim.fn['copilot#TextQueuedForInsertion']()
  return vim.fn.split(bar,  [[[ .]\zs]])[1]
end
map('i', '<M-j>', '<Plug>(copilot-next)')
map('i', '<M-k>', '<Plug>(copilot-previous)')
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<M-i>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
map('i', '<M-o>', SuggestOneWord, {expr = true, remap = false})

-- VIM
map('n', 's', function() vim.cmd('update') end, opts)
-- Save on exit insert mode
--autocmd InsertLeave * update
-- Best remap ever
--  Replace currently selected text with default register
--  without yanking it
map('v', 'p', 'pgvy', opts)
map('', 'c', '"_c', opts)
map('v', 'P', 'pgvy', opts)
-- Add blank line below
map('n', '_', 'o<Esc>k', opts)
-- More comfortable keybindig for alternate-file
map('i', '<M-w>', '<ESC>:e#<CR>a', opts)
map('n', '<M-w>', ':e#<CR>', opts)
map('i', '<M-q>', '<ESC>:wincmd p<CR>a', opts)
map('n', '<M-q>', ':wincmd p<CR>', opts)
-- Alternative escape
map('i', 'jk', '<ESC>', opts)
map('i', 'kj', '<ESC>', opts)
-- Yank a region without moving the cursor to the top of the block
map('v', 'y', 'ygv<Esc>', opts)
-- Remap increase number
map('n', '<C-c>', '<C-a>', opts)
-- Move cursor in insert mode
map('i', '<M-l>', '<Right>', opts)
map('i', '<M-ñ>', '<Left>', opts)
-- Avoid unintentionally macro recording
map('n', 'q', '<Nop>', opts)
map('n', 'qq', 'q', opts)
--- Best remaps ever ---
-- Behave Vim
map('n', 'Y', 'yg$', opts)
--" Keeping it centered
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)
map('n', 'J', 'mzJ`z', opts)
-- Moving text
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)
-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
--  so that you can undo CTRL-U after inserting a line break.
--  Revert with ":iunmap <C-U>".
map('i', '<C-U>', '<C-G>u<C-U>', opts)
-- Move between buffers
-- map('n', '<leader><leader>', ':buffers<CR>:b<space>', opts)
-- Custom hjkl remap
map('', 'ñ', 'h', opts)
map({'n', 'v'}, 'Ñ', ':', opts)
map('n', 'qÑ', 'q:', opts)
map('n', '@Ñ', '@:', opts)
map('n', '<C-w>ñ', '<C-w>h', opts)
-- hl search, no jump, no blink
-- map('n', '*', 'msHmt`s*`tzt`s', opts)
map('n', '+', ':noh<CR>', opts)
-- Delete in insert mode
map('i', '<C-d>', '<Del>', opts)
-- Ex
map('n', '<M-e>', '<cmd>Ex<CR>', opts)
-- Unicode symbols
map('i', '<C-a>', '➜', opts)
-- Filename suggestions
map('i', '<C-f>', '<C-x><C-f>', opts)
-- Auto-expansion
map('i', '(<CR>', '(<CR>)<C-c>O', opts)
map('i', '{<CR>', '{<CR>}<C-c>O', opts)
map('i', '[<CR>', '[<CR>]<C-c>O', opts)
map('i', '(<Space>', '()<Left>', opts)
map('i', '{<Space>', '{}<Left>', opts)
map('i', '[<Space>', '[]<Left>', opts)
map('i', '\'<Space>', '\'\'<Left>', opts)
map('i', '"<Space>', '""<Left>', opts)
-- Terminal
map('t', '<M-x>', '<C-\\><C-n>', opts)
map('t', '<M-q>', '<C-\\><C-n>:wincmd p<CR>', opts)
map('t', '<M-w>', '<C-\\><C-n>:e#<CR>', opts)
-- Bottom terminal
map('n', '<C-t>', '<cmd>sp <bar> res 10 <bar> te<CR>', opts)

-- Search and replace selected text starting from the cursor position
-- \V: very nomagic: do not use regex
map('v', '<C-r>', '"hy:,$s/\\V<C-r>h//gc<left><left><left>', opts)
-- Paste and indent
map({'n', 'v'}, '<C-p>', 'pgvy`[v`]=<Esc>', opts)
map('i', '<C-p>', '<Esc>p`[v`]=<Esc>', opts)

local expr_opts = {noremap = true, expr = true}
-- Move cursor by display lines
-- Jump regular lines when using numbers
map('n', 'j', "v:count ? 'j' : 'gj'", expr_opts)
map('n', 'k', "v:count ? 'k' : 'gk'", expr_opts)
map('v', 'j', "v:count ? 'j' : 'gj'", expr_opts)
map('v', 'k', "v:count ? 'k' : 'gk'", expr_opts)

local expr_opts_silent = {noremap = true, expr = true, silent = true}
-- Always use global marks
map('n', "'",  '"`" . toupper(nr2char(getchar())) . "zz"', expr_opts_silent)
map('n', "m", '"m" . toupper(nr2char(getchar()))', expr_opts_silent)


---- User commands
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

--------------------------------------------------------------------------------
-- Autocommands

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
      pattern = {"javascript", "typescript", "lua" },
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
