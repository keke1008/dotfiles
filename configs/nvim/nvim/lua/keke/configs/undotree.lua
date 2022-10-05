local sidemenu = require "keke.sidemenu"

sidemenu.register('u', {
    name = 'undotree',
    open = function()
        vim.cmd [[
            UndotreeShow
            UndotreeFocus
        ]]
    end,
    close = function()
        vim.cmd [[UndotreeHide]]
    end
})
