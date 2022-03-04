local require_conf = require'utils'.require_conf

return function(use)
    -- Completion
    use {
        'saadparwaiz1/cmp_luasnip',
        config = require_conf'cmp-conf',
        requires = {
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip'

        }
    }

    -- LSP
    use {
        'williamboman/nvim-lsp-installer',
        config = require_conf'lsp',
        requires = {
            'nvim-telescope/telescope.nvim',
            'neovim/nvim-lspconfig',
            'ray-x/lsp_signature.nvim',
             'hrsh7th/cmp-nvim-lsp',
        },
    }

    -- Formatter
    use {
        "jose-elias-alvarez/null-ls.nvim",
        config = require_conf'null-ls-conf',
        requires = "nvim-lua/plenary.nvim",
    }
end
