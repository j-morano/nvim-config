---- VIM options

-- Show @@@ in the last line if it is truncated.
vim.opt.display = 'truncate'
-- Show a few lines of context around the cursor. Note that this makes the
--  text scroll if you mouse-click near the start or end of the window.
vim.opt.scrolloff = 0
-- Time out for key codes
vim.opt.ttimeout = false
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
vim.opt.showbreak = '···'
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
-- Copy to system clipboard
--  Dependency: clipboard software. For example: xclip
vim.opt.clipboard:append('unnamedplus')
-- Do not highlight current word occurences
vim.opt.hlsearch = false
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

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.foldopen:remove({ "hor" })

---- Window options
-- Custom highlights
vim.w.m1 = vim.fn.matchadd('Todo', 'TODO')
vim.w.m1 = vim.fn.matchadd('Todo', 'NOTE')


---- VIM global variables
vim.g.cursorword_highlight = 0
vim.g.cursorword_delay = 0
-- Map leader to space
vim.g.mapleader = ' '
-- Tex: solve excessive error highlighting
vim.g.tex_no_error = 1
-- Python syntax highlighting for Vim
vim.g.python_highlight_all = 1
---- Netrw
-- Do not move the cursor when returning to it
vim.g.netrw_fastbrowse = 2
-- Always show line numbers
vim.g.netrw_bufsettings = 'noma nomod rnu nobl nowrap ro'
-- Copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
