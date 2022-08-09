vim.cmd 'colorscheme nightfox'

vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, 'NvimTreeNormal', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'NvimTreeWindowPicker', { link = 'Normal' })
    end
})
