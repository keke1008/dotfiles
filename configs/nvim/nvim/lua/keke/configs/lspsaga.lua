local M = {}

function M.setup() end

function M.config()
    local saga = require("lspsaga")

    saga.setup({
        ui = {
            border = "rounded",
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

    vim.api.nvim_set_hl(0, "SagaBorder", { link = "FloatBorder" })
end

return M
