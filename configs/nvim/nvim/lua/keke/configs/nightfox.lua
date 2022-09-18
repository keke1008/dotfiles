vim.cmd 'colorscheme nightfox'

vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    once = true,
    callback = function()
        vim.api.nvim_set_hl(0, 'Visual', { bg = "#385275" })
    end
})
