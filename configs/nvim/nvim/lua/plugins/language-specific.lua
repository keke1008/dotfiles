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
        config = [[require'config.rust-tools-conf']],
    }
end
