local require_conf = require'utils'.require_conf

return function(use)
    -- Change filetype
    use {
        'osyo-manga/vim-precious',
        opt = true,
        ft = { 'html', 'markdown' },
        requires = 'Shougo/context_filetype.vim',
        config = require_conf'precious',
    }

    -- Shows a git diff in the sign column.
    use 'airblade/vim-gitgutter'

    -- Filer
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = require_conf'nvim-tree',
    }

    -- Resize Window
    use 'simeji/winresizer'

    --Fuzzy finder
    use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- Statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = require_conf'lualine-conf',
    }

    -- Highlight
    use {
        'nvim-treesitter/nvim-treesitter',
        event = 'BufRead',
        config = require_conf'treesitter',
    }

    -- Colorscheme
    use {
        'EdenEast/nightfox.nvim',
        requires = 'kyazdani42/nvim-tree.lua',
        config = require_conf'nightfox-conf',
    }
end
