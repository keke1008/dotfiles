local require_conf = require'utils'.require_conf

return function(use)
    -- lua
    use {
        'folke/lua-dev.nvim',
        requires = 'neovim/nvim-lspconfig',
    }

    -- rust
    use {
        'simrat39/rust-tools.nvim',
        ft = 'rust',
        config = require_conf'rust-tools-conf',
    }
end
