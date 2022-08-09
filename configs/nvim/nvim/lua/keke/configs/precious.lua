vim.g.precious_enable_switch_CursorMoved = { ["*"] = 0 }
vim.g.precious_enable_switch_CursorMoved_i = { ["*"] = 0 }
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = '*',
    command = ":PreciousSwitch"
})
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = '*',
    command = ':PreciousReset'
})
