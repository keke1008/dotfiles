local require_conf = require'utils'.require_conf

return function(use)
    -- Surrounding
    use 'tpope/vim-surround'

    -- Repeat
    use 'tpope/vim-repeat'

    -- Git commands
    use 'tpope/vim-fugitive'

    -- Textobj
    use {
        'sgur/vim-textobj-parameter',
        requires = 'kana/vim-textobj-user',
        after = 'vim-textobj-user'
    }

    -- Format
    use 'junegunn/vim-easy-align'

    -- Keymap
    use 'LionC/nest.nvim'

    -- Cursor motion
    use 'skanehira/jumpcursor.vim'

    -- Comment
    use { 'echasnovski/mini.nvim', config = require_conf'mini' }

    -- AutoPairs
    use {
        'windwp/nvim-autopairs',
        config = function ()
            require'nvim-autopairs'.setup({map_cr = false})
        end
    }
end
