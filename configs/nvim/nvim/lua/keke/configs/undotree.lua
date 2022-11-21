local menu = require("keke.side_menu")

menu.register("undotree", "u", {
    position = "left",
    open = function()
        vim.cmd([[
            UndotreeShow
            UndotreeFocus
        ]])
    end,
    close = function() vim.cmd([[UndotreeHide]]) end,
})
