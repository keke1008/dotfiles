-- Packer bootstrapping
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local packer = require("packer")

local reload = function(profile)
    package.loaded["keke.plugins"] = nil
    require("keke.plugins")
    packer.install()
    packer.compile(profile and "profile=true" or nil)
end

vim.api.nvim_create_user_command("PackerReload", function() reload(false) end, {})
vim.api.nvim_create_user_command("PackerReloadWithProfile", function() reload(true) end, {})

packer.startup(function(use)
    -- Packer
    use("wbthomason/packer.nvim")

    --------------------------------------------------
    -- Operation
    --------------------------------------------------

    -- Surrounding
    use({
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup() end,
    })

    -- Repeat
    use("tpope/vim-repeat")

    --- Git
    use({
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        config = function() require("keke.configs.gitsigns") end,
    })

    -- Textobj
    use({
        "sgur/vim-textobj-parameter",
        requires = "kana/vim-textobj-user",
        after = "vim-textobj-user",
    })

    -- Format
    use({
        "junegunn/vim-easy-align",
        keys = { "<Plug>(EasyAlign)" },
        setup = function() vim.keymap.set({ "n", "x" }, "ga", "<Plug>(EasyAlign)") end,
    })

    -- Cursor motion
    use({
        "ggandor/leap.nvim",
        config = function() require("keke.configs.leap") end,
    })
    use({
        "skanehira/jumpcursor.vim",
        keys = { "<Plug>(jumpcursor-jump)" },
        setup = function() vim.keymap.set("n", "gj", "<Plug>(jumpcursor-jump)") end,
    })

    -- Edge motion
    use({
        "haya14busa/vim-edgemotion",
        keys = { "<Plug>(edgemotion-" },
        setup = function() require("keke.configs.edgemotion") end,
    })

    -- Comment
    use({
        "numToStr/Comment.nvim",
        keys = { "gc" },
        config = function() require("Comment").setup() end,
    })

    -- AutoPairs
    use({
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function() require("nvim-autopairs").setup() end,
    })

    -- Auto close/rename HTML tag
    use({
        "windwp/nvim-ts-autotag",
        config = function() require("nvim-ts-autotag").setup() end,
    })

    -- Improve *
    use({
        "haya14busa/vim-asterisk",
        keys = { "<Plug>(asterisk-" },
        setup = function() require("keke.configs.asterisk") end,
    })

    -- Undo tree
    use({
        "mbbill/undotree",
        cmd = { "UndotreeShow", "UndotreeHide", "UndotreeToggle", "UndotreeFocus" },
        setup = function() require("keke.configs.undotree") end,
    })

    -- Substitute operator
    use({
        "gbprod/substitute.nvim",
        module = "substitute",
        setup = function() require("keke.configs.substitute") end,
    })

    --- Translation
    use({
        "voldikss/vim-translator",
        cmd = { "Translate*" },
        setup = function() require("keke.configs.vim-translator") end,
    })

    --- Terminal
    use({
        "akinsho/toggleterm.nvim",
        tag = "*",
        cmd = "ToggleTerm",
        setup = function() require("keke.configs.toggleterm").setup() end,
        config = function() require("keke.configs.toggleterm").config() end,
    })

    --- Session manager
    use({
        "Shatur/neovim-session-manager",
        requires = "nvim-lua/plenary.nvim",
        config = function() require("keke.configs.neovim-session-manager") end,
    })

    --------------------------------------------------
    -- LSP
    --------------------------------------------------

    -- Install and configure LSP, DAP, linter, formatter
    use({
        "williamboman/mason.nvim",
        requires = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "jay-babu/mason-null-ls.nvim",
            "jose-elias-alvarez/null-ls.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "folke/neoconf.nvim",
        },
        config = function() require("keke.configs.mason") end,
    })

    --Snippet
    use({
        "L3MON4D3/LuaSnip",
        requires = { "rafamadriz/friendly-snippets" },
        config = function() require("keke.configs.luasnip") end,
    })

    -- Completion
    use({
        "hrsh7th/nvim-cmp",
        module = { "cmp" },
        requires = {
            { "hrsh7th/cmp-nvim-lsp", event = { "InsertEnter" } },
            { "saadparwaiz1/cmp_luasnip", event = { "InsertEnter" } },
            { "hrsh7th/cmp-cmdline", event = { "CmdLineEnter" } },
            { "hrsh7th/cmp-buffer", event = { "InsertEnter" } },
            { "ray-x/cmp-treesitter", event = { "InsertEnter" } },
            { "hrsh7th/cmp-path", event = { "InsertEnter", "CmdLineEnter" } },
            { "onsails/lspkind.nvim", opt = true },
            { "lukas-reineke/cmp-under-comparator", opt = true },
        },
        wants = { "lspkind.nvim", "cmp-under-comparator" },
        config = function() require("keke.configs.cmp") end,
    })

    -- Debugger
    use({
        "mfussenegger/nvim-dap",
        requires = {
            { "rcarriga/nvim-dap-ui", opt = true },
            { "theHamsta/nvim-dap-virtual-text", opt = true },
        },
        wants = { "nvim-dap-ui", "nvim-dap-virtual-text" },
        module = { "dap" },
        cmd = { "Dap*" },
        setup = function() require("keke.configs.dap").setup() end,
        config = function() require("keke.configs.dap").config() end,
    })

    -- Showing diagnostics, reference, ...
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        cmd = { "Trouble" },
        module = { "toruble" },
        setup = function() require("keke.configs.trouble").setup() end,
        config = function() require("keke.configs.trouble").config() end,
    })

    -- LSP UI plugin
    use({
        "glepnir/lspsaga.nvim",
        cmd = { "Lspsaga" },
        module = { "lspsaga" },
        setup = function() require("keke.configs.lspsaga").setup() end,
        config = function() require("keke.configs.lspsaga").config() end,
    })

    -- Scroll bar with diagnostics
    use({
        "petertriho/nvim-scrollbar",
        config = function() require("keke.configs.nvim-scrollbar") end,
    })

    --------------------------------------------------
    -- Language-specifig LSP plugins
    --------------------------------------------------

    -- lua
    use({
        "folke/neodev.nvim",
        ft = "lua",
        config = function() require("keke.configs.neodev") end,
    })

    -- rust
    use({
        "simrat39/rust-tools.nvim",
        ft = "rust",
        config = function() require("keke.configs.rust-tools") end,
    })

    -- c/c++
    use({
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp" },
        config = function() require("keke.configs.clangd_extensions") end,
    })

    -- java
    use({
        "mfussenegger/nvim-jdtls",
        ft = "java",
    })

    -- python
    use({
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function() require("keke.configs.nvim-dap-python") end,
    })

    -- js/ts
    use({
        "jose-elias-alvarez/typescript.nvim",
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        config = function() require("keke.configs.typescript") end,
    })

    --------------------------------------------------
    -- Appearance
    --------------------------------------------------

    -- Filer
    use({
        "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
        module = { "nvim-tree." }, -- `nvim-treesitter` matches the pattern "nvim-tree".
        setup = function() require("keke.configs.nvim-tree").setup() end,
        config = function() require("keke.configs.nvim-tree").config() end,
    })

    -- Scroll animation
    use({
        "karb94/neoscroll.nvim",
        config = function() require("keke.configs.neoscroll") end,
    })

    --Fuzzy finder
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-ui-select.nvim", opt = true },
        },
        wants = { "telescope-ui-select.nvim" },
        cmd = { "Telescope" },
        module = { "telescope" },
        setup = function() require("keke.configs.telescope").setup() end,
        config = function() require("keke.configs.telescope").config() end,
    })

    -- Indent line
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function() require("keke.configs.indent-blankline") end,
    })

    -- Zen mode
    use({
        "folke/zen-mode.nvim",
        module = { "zen-mode" },
        setup = function() require("keke.configs.zen-mode").setup() end,
        config = function() require("keke.configs.zen-mode").config() end,
    })

    -- Key binding helper
    use({
        "folke/which-key.nvim",
        config = function() require("which-key").setup() end,
    })

    -- Statusline
    use({
        "nvim-lualine/lualine.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function() require("keke.configs.lualine") end,
    })

    -- cmdheight=0
    use({
        "folke/noice.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function() require("keke.configs.noice") end,
    })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        requires = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/nvim-treesitter-context",
            "andymass/vim-matchup",
        },
        event = "BufRead",
        config = function() require("keke.configs.treesitter") end,
    })

    -- Colorscheme
    use({
        "folke/tokyonight.nvim",
        config = function() vim.cmd([[colorscheme tokyonight-night]]) end,
    })

    --------------------------------------------------
    -- Other
    --------------------------------------------------

    -- Improve neovim startup time
    use("lewis6991/impatient.nvim")

    if packer_bootstrap then packer.sync() end
end)
