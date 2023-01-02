return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Visual information
  use 'lukas-reineke/indent-blankline.nvim'
  use 'mhinz/vim-signify'
  use 'norcalli/nvim-colorizer.lua'

  -- Colorscheme and treesitter
  use({ 'folke/tokyonight.nvim', as = 'tokyonight' })
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- tpope
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'

  -- File navigation
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'j-morano/buffer_manager.nvim'

  -- Snippets
  use 'L3MON4D3/LuaSnip'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'ray-x/lsp_signature.nvim'
  use 'github/copilot.vim'

  -- Rust development
  use 'simrat39/rust-tools.nvim'
  -- Python development
  use 'Vimjas/vim-python-pep8-indent'
  use 'vim-python/python-syntax'

  -- Completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/nvim-cmp'
end)
