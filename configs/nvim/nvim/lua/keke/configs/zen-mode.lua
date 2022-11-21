local zen_mode = require("zen-mode")
local menu = require("keke.side_menu")

zen_mode.setup({})

menu.register("zen-mode", "z", {
    position = { "left", "right", "bottom" },
    open = zen_mode.open,
    close = zen_mode.close,
})
