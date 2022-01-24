local require_conf = require'utils'.require_conf

return function(use)
    -- Snippet
    use {
        -- 2022/01/24
        --If this plugin is loaded after Treesitter, an error will occur.
        'L3MON4D3/LuaSnip',
        config = require_conf'luasnip-conf'
    }

    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        config = require_conf'cmp-conf',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'saadparwaiz1/cmp_luasnip',
        },
    }

    -- LSP
    use {
        'williamboman/nvim-lsp-installer',
        config = require_conf'lsp',
        requires = {
            'nvim-telescope/telescope.nvim',
            'neovim/nvim-lspconfig',
            'ray-x/lsp_signature.nvim',
        }
    }
end
