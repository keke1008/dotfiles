local require_conf = require'utils'.require_conf

return function(use)
    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        config = require_conf'cmp-conf',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/vim-vsnip',
        },
    }

    -- LSP
    use {
        'williamboman/nvim-lsp-installer',
        config = require_conf'lsp',
        requires = {
            'nvim-telescope/telescope.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'ray-x/lsp_signature.nvim',
        }
    }
end
