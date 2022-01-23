local require_conf = require'utils'.require_conf

return function(use)
    -- Surrounding
    use 'tpope/vim-surround'

    -- Repeat
    use 'tpope/vim-repeat'

    -- Git commands
    use 'tpope/vim-fugitive'

    -- Textobj
    use { 'sgur/vim-textobj-parameter', requires = 'kana/vim-textobj-user' }

    -- Format
    use {
        'junegunn/vim-easy-align',
        config = require_conf'vim-easy-align',
    }

    -- Call lua function in keymap
    use 'svermeulen/vimpeccable'

    -- Motion
    use {
        'justinmk/vim-sneak',
        setup = function () vim.g['sneak#s_next'] = 1 end ,
        config = require_conf'vim-sneak'
    }

    -- Comment and AutoPairs
    use { 'echasnovski/mini.nvim', config = require_conf'mini' }
end
