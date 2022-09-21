-- Install packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    _G.packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
    vim.cmd 'packadd packer.nvim'
end

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

    -- Edge motion
    use {
        'haya14busa/vim-edgemotion',
        config = function() require 'keke.configs.edgemotion' end
    }

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

    -- Improve *
    use {
        'haya14busa/vim-asterisk',
        config = function() require 'keke.configs.asterisk' end
    }


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

    --Snippet
    use {
        'L3MON4D3/LuaSnip',
        config = function() require 'keke.configs.luasnip' end
    }

    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            { 'onsails/lspkind.nvim', event = { 'InsertEnter', 'CmdlineEnter' } },
            { 'saadparwaiz1/cmp_luasnip', event = { 'InsertEnter', 'CmdlineEnter' } },
            { 'hrsh7th/cmp-cmdline', event = { 'InsertEnter', 'CmdlineEnter' } },
            { 'hrsh7th/cmp-buffer', event = { 'InsertEnter', 'CmdlineEnter' } },
            { 'ray-x/cmp-treesitter', event = { 'InsertEnter', 'CmdlineEnter' } },
        },
        after = {
            'LuaSnip',
            'lspkind.nvim',
            'cmp_luasnip',
            'cmp-nvim-lsp',
            'cmp-cmdline',
            'cmp-buffer',
            'cmp-treesitter',
        },
        config = function() require 'keke.configs.cmp' end
    }

    -- Debugger
    use {
        'mfussenegger/nvim-dap',
        requires = 'rcarriga/nvim-dap-ui',
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
    use {
        'airblade/vim-gitgutter',
        setup = function() vim.g.gitgutter_map_keys = 0 end,
        config = function() vim.g.gitgutter_sign_priority = 0 end
    }

    -- Filer
    use {
        'lambdalisue/fern.vim',
        requires = { 'antoinemadec/FixCursorHold.nvim' },
        cmd = { 'Fern', 'FernDo' },
        setup = function() require 'keke.configs.fern' end,
    }
    use {
        'lambdalisue/fern-git-status.vim',
        after = 'fern.vim',
        config = function()
            vim.fn['fern_git_status#init']()
        end
    }
    use {
        'lambdalisue/fern-renderer-nerdfont.vim',
        after = { 'fern.vim', 'nerdfont.vim', 'glyph-palette.vim' },
        requires = {
            { 'lambdalisue/nerdfont.vim', after = 'fern.vim' },
            { 'lambdalisue/glyph-palette.vim', after = 'fern.vim' },
        }
    }

    -- Scroll animation
    use {
        'karb94/neoscroll.nvim',
        config = function() require 'keke.configs.neoscroll' end
    }

    -- UI
    use {
        'stevearc/dressing.nvim',
        config = function() require 'dressing'.setup() end
    }

    --Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = 'nvim-lua/plenary.nvim',
    }

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
        config = function() require 'keke.configs.nightfox' end
    }

    --------------------------------------------------
    -- Other
    --------------------------------------------------

    -- Improve neovim startup time
    use 'lewis6991/impatient.nvim'

    -- Replace filetype.vim
    use 'nathom/filetype.nvim'

    if packer_bootstrap then
        packer.sync()
    end
end)
