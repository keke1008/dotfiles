local drawer = require("drawer")
local keymap = require("keke.keymap")

local drawer_name = "filer"
local nvim_tree_buffers = keymap.lib.BufferSet.new()
keymap.helper.nvim_tree_buffers = nvim_tree_buffers

return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "stevearc/oil.nvim",
        },
        cmd = { "NvimTree" },
        keys = {
            {
                drawer.with_prefix_key("e"),
                function()
                    drawer.open(drawer_name)
                end,
                desc = "open filer",
            },
        },
        init = function()
            drawer.register({
                name = drawer_name,
                positions = { "left" },
                open = "NvimTreeOpen",
                close = "NvimTreeClose",
            })
        end,
        opts = {
            sync_root_with_cwd = true,
            filters = {
                dotfiles = true,
            },
            on_attach = function(bufnr)
                nvim_tree_buffers:add(bufnr)
            end,
        },
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = true,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                vim.cmd([[Lazy load telescope.nvim]])
                vim.ui.select(...)
            end
        end,
        cmd = "Telescope",
        config = function()
            local telescope = require("telescope")
            local themes = require("telescope.themes")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        themes.get_dropdown({}),
                    },
                },
            })

            telescope.load_extension("ui-select")
        end,
    },
}
