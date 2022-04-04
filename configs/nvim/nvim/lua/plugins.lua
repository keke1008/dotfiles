local require_conf = require'utils'.require_conf
local packer = require'packer'

local M = {}

M.startup = function()
    packer.startup(function(use)

        -- Packer
        use 'wbthomason/packer.nvim'

        --------------------------------------------------
        -- Operation
        --------------------------------------------------

        -- Keymap
        use 'LionC/nest.nvim'

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


        --------------------------------------------------
        -- Languages
        --------------------------------------------------

        -- lua
        use 'folke/lua-dev.nvim'

        -- rust
        use {
            'simrat39/rust-tools.nvim',
            ft = 'rust',
            config = require_conf'rust-tools-conf',
        }


        --------------------------------------------------
        -- General purpose
        --------------------------------------------------

        -- Completion
        use {
            'saadparwaiz1/cmp_luasnip',
            config = require_conf'cmp-conf',
            requires = {
                'hrsh7th/nvim-cmp',
                'L3MON4D3/LuaSnip'

            }
        }

        -- LSP
        use {
            'williamboman/nvim-lsp-installer',
            config = require_conf'lsp',
            requires = {
                'nvim-telescope/telescope.nvim',
                'neovim/nvim-lspconfig',
                'ray-x/lsp_signature.nvim',
                 'hrsh7th/cmp-nvim-lsp',
            },
        }

        -- Formatter
        use {
            "jose-elias-alvarez/null-ls.nvim",
            config = require_conf'null-ls-conf',
            requires = "nvim-lua/plenary.nvim",
        }

        -- Debugger
        use {
            'rcarriga/nvim-dap-ui',
            requires = 'mfussenegger/nvim-dap',
            cond = function() return vim.fn.executable('lldb') == 1 end,
            config = require_conf'dap-conf'
        }

        -- Change filetype
        use {
            'osyo-manga/vim-precious',
            opt = true,
            ft = { 'html', 'markdown' },
            requires = 'Shougo/context_filetype.vim',
            config = require_conf'precious',
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
    end)
end

M.reload = function()
    package.loaded['plugins'] = nil
    require'plugins'.startup()
    packer.install()
    packer.compile()
end

vim.cmd[[
    command! Reload lua require'plugins'.reload()
]]

return M
