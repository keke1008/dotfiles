local menu = require("keke.side_menu")

local M = {}

function M.setup()
    menu.register("trouble", "t", {
        position = "bottom",
        open = function() vim.cmd([[Trouble]]) end,
        close = function() vim.cmd([[TroubleClose]]) end,
    })
end

function M.config()
    local trouble = require("trouble")

    trouble.setup({
        action_keys = {
            open_split = "s",
            open_vsplit = "v",
            open_tab = "t",
            toggle_fold = "e",
        },
    })
end

return M
