local nvim_tree = require'nvim-tree'

nvim_tree.setup {
    git = {
        ignore = false,
    },
    open_on_tab = true,
    open_on_setup = true
}
