local vimp = require'vimp'
local nvim_tree = require'nvim-tree'

vimp.nnoremap('<leader>ep', '<CMD>NvimTreeFindFile<CR>')

nvim_tree.setup {
    view = {
        auto_resize = true,
        signcolumn = "yes",
    },
    git = {
        ignore = false,
    },
    open_on_tab = true,
    open_on_setup = true
}
