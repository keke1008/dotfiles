vim.g.precious_enable_switch_CursorMoved = { ["*"] = 0 }
vim.g.precious_enable_switch_CursorMoved_i = { ["*"] = 0 }
vim.cmd [[
    augroup filetype
        autocmd!
        autocmd InsertEnter * :PreciousSwitch
        autocmd InsertLeave * :PreciousReset
    augroup END
]]
