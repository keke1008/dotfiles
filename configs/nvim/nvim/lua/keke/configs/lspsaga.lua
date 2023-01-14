local M = {}

function M.setup()
    local menu = require("keke.side_menu")

    menu.register("lspsaga outline", "o", {
        position = "right",
        open = function() require("lspsaga.outline"):render_outline(true) end,
        close = function() require("lspsaga.outline"):render_outline() end,
    })
end

function M.config()
    local saga = require("lspsaga")

    saga.setup({
        ui = {
            border = "solid",
        },
        lightbulb = {
            enable = false,
        },
        finder = {
            open = "e",
            vsplit = "v",
            split = "i",
            tabe = "t",
            quit = "<ESC>",
        },
        definition = {
            edit = "<leader>:e",
            vsplit = "<leader>:v",
            split = "<leader>:s",
            tabe = "<leader>:t",
        },
        outline = {
            keys = {
                jump = "e",
            },
        },
        symbol_in_winbar = {
            enable = true,
        },
    })
end

return M
