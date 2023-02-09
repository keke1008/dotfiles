local map = require("keke.utils.mapping")

local M = {}

function M.setup()
    local menu = require("keke.side_menu")
    menu.register("nvim-tree", "e", {
        position = "left",
        open = function() require("nvim-tree.api").tree.open() end,
        close = function() require("nvim-tree.api").tree.close() end,
    })
end

function M.config()
    local nvim_tree = require("nvim-tree")
    local nvim_tree_api = require("nvim-tree.api")

    nvim_tree.setup({
        sync_root_with_cwd = true,
        filters = {
            dotfiles = true,
        },
        remove_keymaps = true,
        on_attach = function(bufnr)
            local opts = { buffer = bufnr, noremap = true, nowait = true }
            vim.keymap.set("n", "e", nvim_tree_api.node.open.edit, map.add_desc(opts, "edit"))
            vim.keymap.set("n", "v", nvim_tree_api.node.open.vertical, map.add_desc(opts, "vsplit"))
            vim.keymap.set("n", "s", nvim_tree_api.node.open.horizontal, map.add_desc(opts, "split"))
            vim.keymap.set("n", "t", nvim_tree_api.node.open.tab, map.add_desc(opts, "tabedit"))

            vim.keymap.set("n", "w", nvim_tree_api.tree.change_root_to_node, map.add_desc(opts, "enter directory"))
            vim.keymap.set("n", "b", nvim_tree_api.tree.change_root_to_parent, map.add_desc(opts, "leave directory"))
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
    })
end

return M
