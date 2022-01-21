return function(use)
    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        config = [[require'config.cmp-conf']],
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/vim-vsnip',
        },
    }

    -- LSP
    use {
        'williamboman/nvim-lsp-installer',
        config = [[require'config.lsp']],
        requires = {
            'nvim-telescope/telescope.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'ray-x/lsp_signature.nvim',
        }
    }
end
