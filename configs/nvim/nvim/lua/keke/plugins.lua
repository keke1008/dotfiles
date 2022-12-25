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

    -- Git commands
    use("tpope/vim-fugitive")

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

    -- Show register content
    use({
        "tversteeg/registers.nvim",
        keys = { { "n", '"' }, { "x", '"' }, { "i", "<C-r>" } },
        cmd = { "Registers" },
        config = function() require("keke.configs.registers") end,
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

    use({
        "voldikss/vim-translator",
        cmd = { "Translate*" },
        setup = function() require("keke.configs.vim-translator") end,
    })

    --------------------------------------------------
    -- LSP
    --------------------------------------------------

    -- Global/Local lsp settings
    use({ "folke/neoconf.nvim" })

    -- Install and configure LSP, DAP, linter, formatter
    use({
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
    })

    -- General purposes lunguage server
    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function() require("keke.configs.null-ls") end,
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
        requires = { { "rcarriga/nvim-dap-ui", opt = true } },
        wants = { "nvim-dap-ui" },
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
        setup = require("keke.configs.trouble").setup,
        config = require("keke.configs.trouble").config,
    })

    -- LSP UI plugin
    use({
        "glepnir/lspsaga.nvim",
        cmd = { "Lspsaga" },
        module = { "lspsaga" },
        setup = require("keke.configs.lspsaga").setup,
        config = require("keke.configs.lspsaga").config,
    })

    -- Show LSP status
    use({
        "j-hui/fidget.nvim",
        config = function() require("fidget").setup({}) end,
    })

    -- Show function signature
    use({
        "ray-x/lsp_signature.nvim",
        config = function() require("keke.configs.lsp_signature") end,
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

    -- Shows a git diff in the sign column.
    use({
        "airblade/vim-gitgutter",
        setup = function() vim.g.gitgutter_map_keys = 0 end,
        config = function() vim.g.gitgutter_sign_priority = 0 end,
    })

    -- Filer
    use({
        "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
        module = { "nvim-tree." }, -- `nvim-treesitter` matches the pattern "nvim-tree".
        setup = require("keke.configs.nvim-tree").setup,
        config = require("keke.configs.nvim-tree").config,
    })

    -- Scroll animation
    use({
        "karb94/neoscroll.nvim",
        config = function() require("keke.configs.neoscroll") end,
    })

    -- UI
    use({
        "stevearc/dressing.nvim",
        config = function() require("dressing").setup() end,
    })

    --Fuzzy finder
    use({
        "nvim-telescope/telescope.nvim",
        requires = "nvim-lua/plenary.nvim",
        cmd = { "Telescope" },
        module = { "telescope" },
        setup = require("keke.configs.telescope").setup,
        config = require("keke.configs.telescope").config,
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
        setup = require("keke.configs.zen-mode").setup,
        config = require("keke.configs.zen-mode").config,
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
