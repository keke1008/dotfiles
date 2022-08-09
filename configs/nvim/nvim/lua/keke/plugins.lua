local packer = require 'packer'

local reload = function(profile)
    package.loaded['keke.plugins'] = nil
    require 'keke.plugins'
    packer.install()
    packer.compile(profile and 'profile=true' or nil)
end

vim.api.nvim_create_user_command('PackerReload', function() reload(false) end, {})
vim.api.nvim_create_user_command('PackerReloadWithProfile', function() reload(true) end, {})


packer.startup(function(use)

    -- Packer
    use 'wbthomason/packer.nvim'

    --------------------------------------------------
    -- Operation
    --------------------------------------------------

    -- Surrounding
    use {
        'kylechui/nvim-surround',
        config = function() require 'nvim-surround'.setup() end
    }

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

    -- Cursor motion
    use 'skanehira/jumpcursor.vim'

    -- Comment
    use {
        'numToStr/Comment.nvim',
        config = function() require 'Comment'.setup() end
    }

    -- AutoPairs
    use {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function() require 'nvim-autopairs'.setup() end
    }

    -- Show register content
    use 'tversteeg/registers.nvim'


    --------------------------------------------------
    -- Languages
    --------------------------------------------------

    -- lua
    use 'folke/lua-dev.nvim'

    -- rust
    use {
        'simrat39/rust-tools.nvim',
        branch = 'modularize_and_inlay_rewrite',
        ft = 'rust',
        config = function() require 'keke.configs.rust-tools' end
    }

    -- java
    use {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        config = function() require 'plugins.jdtls-conf' end
    }


    --------------------------------------------------
    -- General purpose
    --------------------------------------------------

    -- LSP
    use {
        'williamboman/mason.nvim',
        requires = {
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'ray-x/lsp_signature.nvim',
            'nvim-telescope/telescope.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function() require 'keke.configs.lsp' end
    }

    -- Completion
    use {
        'saadparwaiz1/cmp_luasnip',
        requires = {
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip'
        },
        config = function() require 'keke.configs.cmp' end
    }

    -- Debugger
    use {
        'mfussenegger/nvim-dap',
        requires = 'rcarriga/nvim-dap-ui',
        ft = { 'rust', 'java' },
        config = function() require 'keke.configs.dap' end
    }

    -- Change filetype
    use {
        'osyo-manga/vim-precious',
        ft = { 'html', 'markdown' },
        requires = 'Shougo/context_filetype.vim',
        config = function() require 'keke.configs.precious' end,
        disable = true,
    }


    --------------------------------------------------
    -- Appearance
    --------------------------------------------------

    -- Shows a git diff in the sign column.
    use 'airblade/vim-gitgutter'

    -- Filer
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() require 'keke.configs.nvim-tree' end
    }

    -- Scroll animation
    use {
        'karb94/neoscroll.nvim',
        config = function() require 'keke.configs.neoscroll' end
    }

    --Fuzzy finder
    use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- Statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() require 'keke.configs.lualine' end
    }

    -- Highlight
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = 'nvim-treesitter/nvim-treesitter',
        event = 'BufRead',
        config = function() require 'keke.configs.treesitter' end
    }

    -- Colorscheme
    use {
        'EdenEast/nightfox.nvim',
        requires = 'kyazdani42/nvim-tree.lua',
        config = function() require 'keke.configs.nightfox' end
    }
end)
