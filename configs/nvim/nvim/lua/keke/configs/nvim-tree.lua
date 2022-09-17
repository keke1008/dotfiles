local nvim_tree = require 'nvim-tree'
local nvim_tree_api = require 'nvim-tree.api'

local sidemenu = require 'keke.sidemenu'

nvim_tree.setup {
    git = {
        ignore = true,
    },
    open_on_tab = true,
    open_on_setup = true,
    filters = {
        dotfiles = true
    }
}

sidemenu.register('<leader>se', {
    name = "nvim-tree",
    open = nvim_tree_api.tree.open,
    close = nvim_tree_api.tree.close
})
