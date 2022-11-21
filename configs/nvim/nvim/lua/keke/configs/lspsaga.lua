local saga = require("lspsaga")
local saga_outline = require("lspsaga.outline")

local menu = require("keke.side_menu")

saga.init_lsp_saga({
    saga_winblend = 30,
    code_action_lightbulb = {
        enable = false,
    },
    finder_action_keys = {
        open = "e",
        vsplit = "v",
        split = "i",
        tabe = "t",
        quit = "<ESC>",
    },
    definition_action_keys = {
        edit = "<leader>:e",
        vsplit = "<leader>:v",
        split = "<leader>:s",
        tabe = "<leader>:t",
    },
    rename_action_quit = "<C-c>",
    show_outline = {
        jump_key = "e",
    },
    symbol_in_winbar = { enable = true },
})

menu.register("o", {
    position = "right",
    open = function() saga_outline:render_outline(true) end,
    close = function() saga_outline:render_outline() end,
})
