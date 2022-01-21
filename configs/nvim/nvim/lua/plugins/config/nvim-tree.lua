local vimp = require'vimp'
vimp.nnoremap('<leader>ep', '<CMD>NvimTreeFindFile<CR>')

require'nvim-tree'.setup {
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
