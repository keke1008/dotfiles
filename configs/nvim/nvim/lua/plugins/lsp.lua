local require_conf = require'utils'.require_conf

return function(use)
    -- Snippet
    -- 2022/01/24
    --If this plugin is loaded after Treesitter, an error will occur.
    use 'L3MON4D3/LuaSnip'

    -- Completion
    use {
        'hrsh7th/cmp-nvim-lsp',
        config = require_conf'cmp-conf',
        requires = 'hrsh7th/nvim-cmp',
    }

    use 'saadparwaiz1/cmp_luasnip'

    -- LSP
    use {
        'williamboman/nvim-lsp-installer',
        config = require_conf'lsp',
        requires = {
            'nvim-telescope/telescope.nvim',
            'neovim/nvim-lspconfig',
            'ray-x/lsp_signature.nvim',
            'cmp-nvim-lsp',
        },
    }

    -- Formatter
    use {
        "jose-elias-alvarez/null-ls.nvim",
        config = require_conf'null-ls-conf',
        requires = "nvim-lua/plenary.nvim",
    }
end
