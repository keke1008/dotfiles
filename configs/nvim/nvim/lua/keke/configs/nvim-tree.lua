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

local handler = sidemenu.register('<leader>se', {
    name = "nvim-tree",
    open = nvim_tree_api.tree.open,
    close = nvim_tree_api.tree.close
})

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = '*',
    callback = function()
        local current = vim.api.nvim_get_current_win()
        handler:open()
        vim.api.nvim_set_current_win(current)
    end
})
