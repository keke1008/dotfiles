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
end

return M
