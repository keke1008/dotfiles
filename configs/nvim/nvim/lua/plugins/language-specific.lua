local require_conf = require'utils'.require_conf

return function(use)
    -- lua
    use 'folke/lua-dev.nvim'

    use {
        'simrat39/rust-tools.nvim',
        ft = 'rust',
        config = require_conf'rust-tools-conf',
    }
end
