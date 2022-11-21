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
    use("junegunn/vim-easy-align")

    -- Cursor motion
    use("skanehira/jumpcursor.vim")

    -- Edge motion
    use({
        "haya14busa/vim-edgemotion",
        config = function() require("keke.configs.edgemotion") end,
    })

    -- Comment
    use({
        "numToStr/Comment.nvim",
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
        config = function() require("keke.configs.registers") end,
    })

    -- Improve *
    use({
        "haya14busa/vim-asterisk",
        config = function() require("keke.configs.asterisk") end,
    })

    -- Undo tree
    use({
        "mbbill/undotree",
        config = function() require("keke.configs.undotree") end,
    })

    --------------------------------------------------
    -- Languages
    --------------------------------------------------

    -- lua
    use("folke/neodev.nvim")

    -- rust
    use({
        "simrat39/rust-tools.nvim",
        branch = "modularize_and_inlay_rewrite",
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
    -- General purpose
    --------------------------------------------------

    -- LSP
    use({
        "williamboman/mason.nvim",
        requires = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "ray-x/lsp_signature.nvim",
            "nvim-telescope/telescope.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "glepnir/lspsaga.nvim",
        },
        config = function() require("keke.configs.lsp") end,
    })

    -- General purposes lunguage server
    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function() require("keke.configs.null-ls") end,
    })

    --Snippet
    use({
        "L3MON4D3/LuaSnip",
        config = function() require("keke.configs.luasnip") end,
    })

    -- Completion
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind.nvim",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-buffer",
            "ray-x/cmp-treesitter",
        },
        config = function() require("keke.configs.cmp") end,
    })

    -- Debugger
    use({
        "mfussenegger/nvim-dap",
        requires = "rcarriga/nvim-dap-ui",
        config = function() require("keke.configs.dap") end,
    })

    -- Showing diagnostics, reference, ...
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function() require("keke.configs.trouble") end,
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
        requires = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function() require("keke.configs.nvim-tree") end,
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

    -- Lsp status
    use({
        "j-hui/fidget.nvim",
        config = function() require("fidget").setup({}) end,
    })

    use({
        "petertriho/nvim-scrollbar",
        config = function() require("keke.configs.nvim-scrollbar") end,
    })

    --Fuzzy finder
    use({
        "nvim-telescope/telescope.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function() require("keke.configs.telescope") end,
    })

    -- Indent line
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function() require("keke.configs.indent-blankline") end,
    })

    -- Zen mode
    use({
        "folke/zen-mode.nvim",
        config = function() require("keke.configs.zen-mode") end,
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
