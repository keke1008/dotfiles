return function()
    require'mini.comment'.setup({})

    if vim.fn.exists'g:vscode' == 0 then
        require'mini.pairs'.setup({})
    end
end
