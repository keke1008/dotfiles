local nvim_tree = require("nvim-tree")
local nvim_tree_api = require("nvim-tree.api")
local sidemenu = require("keke.sidemenu")

local remap = vim.keymap.set

nvim_tree.setup({
    remove_keymaps = true,
    on_attach = function(bufnr)
        local opt = { buffer = bufnr, noremap = true, nowait = true }
        remap("n", "e", nvim_tree_api.node.open.edit, opt)
        remap("n", "v", nvim_tree_api.node.open.vertical, opt)
        remap("n", "s", nvim_tree_api.node.open.horizontal, opt)
        remap("n", "t", nvim_tree_api.node.open.tab, opt)

        remap("n", "w", nvim_tree_api.tree.change_root_to_node, opt)
        remap("n", "b", nvim_tree_api.tree.change_root_to_parent, opt)
        remap("n", "i", function()
            nvim_tree_api.tree.toggle_gitignore_filter()
            nvim_tree_api.tree.toggle_hidden_filter()
        end, opt)

        remap("n", "r", nvim_tree_api.fs.rename, opt)
        remap("n", "c", nvim_tree_api.fs.create, opt)
        remap("n", "d", nvim_tree_api.fs.remove, opt)
        remap("n", "y", nvim_tree_api.fs.copy.node, opt)
        remap("n", "p", nvim_tree_api.fs.paste, opt)
    end,
})

sidemenu.register("e", {
    name = "nvim-tree",
    open = nvim_tree_api.tree.open,
    close = nvim_tree_api.tree.close,
})