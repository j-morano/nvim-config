return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Track the engine.
    use 'SirVer/ultisnips'

    -- Snippets are separated from the engine. Add this if you want them:
    use 'honza/vim-snippets'

    --use 'mhinz/vim-signify'
    use 'airblade/vim-gitgutter'

    use 'NLKNguyen/papercolor-theme'

    use 'lervag/vimtex'

    use 'antoinemadec/FixCursorHold.nvim'

    use 'Vimjas/vim-python-pep8-indent'

    use 'ray-x/lsp_signature.nvim'

    use 'sheerun/vim-polyglot'

    use 'Yggdroot/indentLine'

    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'ThePrimeagen/harpoon'

    use 'neovim/nvim-lspconfig'

    use 'simrat39/rust-tools.nvim'

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'

    use 'itchyny/vim-cursorword'
end)