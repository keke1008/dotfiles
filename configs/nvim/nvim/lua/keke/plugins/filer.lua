local drawer = require("drawer")

local drawer_name = "filer"

return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
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
                local nvim_tree_api = require("nvim-tree.api")
                local map = require("keke.utils.mapping")

                local opts = { buffer = bufnr, noremap = true, nowait = true }
                vim.keymap.set("n", "e", nvim_tree_api.node.open.edit, map.add_desc(opts, "edit"))
                vim.keymap.set("n", "v", nvim_tree_api.node.open.vertical, map.add_desc(opts, "vsplit"))
                vim.keymap.set("n", "s", nvim_tree_api.node.open.horizontal, map.add_desc(opts, "split"))
                vim.keymap.set("n", "t", nvim_tree_api.node.open.tab, map.add_desc(opts, "tabedit"))
                vim.keymap.set("n", "K", nvim_tree_api.node.show_info_popup, map.add_desc(opts, "info"))

                vim.keymap.set("n", "w", nvim_tree_api.tree.change_root_to_node, map.add_desc(opts, "enter directory"))
                vim.keymap.set(
                    "n",
                    "b",
                    nvim_tree_api.tree.change_root_to_parent,
                    map.add_desc(opts, "leave directory")
                )
                vim.keymap.set("n", "i", function()
                    nvim_tree_api.tree.toggle_gitignore_filter()
                    nvim_tree_api.tree.toggle_hidden_filter()
                end, map.add_desc(opts, ""))
                vim.keymap.set("n", "<C-r>", nvim_tree_api.tree.reload, map.add_desc(opts, "reload"))

                vim.keymap.set("n", "r", nvim_tree_api.fs.rename, map.add_desc(opts, "rename"))
                vim.keymap.set("n", "c", nvim_tree_api.fs.create, map.add_desc(opts, "create"))
                vim.keymap.set("n", "d", nvim_tree_api.fs.remove, map.add_desc(opts, "remove"))
                vim.keymap.set("n", "y", nvim_tree_api.fs.copy.node, map.add_desc(opts, "copy"))
                vim.keymap.set("n", "p", nvim_tree_api.fs.paste, map.add_desc(opts, "paste"))
            end,
        },
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
        keys = function()
            local function telescope(name, opts)
                return function()
                    local builtins = require("telescope.builtin")
                    builtins[name](opts)
                end
            end

            return {
                { "<leader>fb", "<CMD>Telescope buffers<CR>", mode = "n" },
                { "<leader>ff", "<CMD>Telescope find_files<CR>", mode = "n" },
                { "<leader>fF", telescope("find_files", { hidden = true }), mode = "n", desc = "find hidden files" },
                { "<leader>fh", "<CMD>Telescope help_tags<CR>", mode = "n" },
                { "<leader>fl", "<CMD>Telescope live_grep<CR>", mode = "n" },
                { "<leader>fm", "<CMD>Telescope marks<CR>", mode = "n" },
                { "<leader>fgf", "<CMD>Telescope git_files<CR>", mode = "n" },
                { "<leader>fgc", "<CMD>Telescope git_commits<CR>", mode = "n" },
                { "<leader>fgC", "<CMD>Telescope git_bcommits<CR>", mode = "n", desc = "commits for current buffer" },
                { "<leader>fgb", "<CMD>Telescope git_branches<CR>", mode = "n" },
                { "<leader>fgs", "<CMD>Telescope git_status<CR>", mode = "n" },
                { "<leader>fgh", "<CMD>Telescope git_stash<CR>", mode = "n" },
                {
                    "<leader>fL",
                    telescope("live_grep", { additional_args = { "--hidden" } }),
                    mode = "n",
                    desc = "live grep hidden files",
                },
            }
        end,
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local themes = require("telescope.themes")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-b>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
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
