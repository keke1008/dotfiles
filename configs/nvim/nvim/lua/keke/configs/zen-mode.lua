local M = {}

function M.setup()
    local menu = require("keke.side_menu")

    menu.register("zen-mode", "z", {
        position = { "left", "right", "bottom" },
        open = function() require("zen-mode").open() end,
        close = function() require("zen-mode").close() end,
    })
end

function M.config()
    local zen_mode = require("zen-mode")
    zen_mode.setup({})
end

return M
