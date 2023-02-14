local M = {}

function M.setup()
    local km = require("keke.utils.mapping")
    local l2 = km.l2

    vim.keymap.set(
        "n",
        l2("tr"),
        function() return require("pantran").motion_translate({ mode = "hover" }) end,
        { expr = true, desc = "Translate" }
    )
    vim.keymap.set("n", l2("trr"), l2("tr_") .. "_", { desc = "Translate line", remap = true })
    vim.keymap.set("n", l2("tR"), l2("tr") .. "$", { desc = "Translate eol", remap = true })
    vim.keymap.set("n", l2("tro"), "<CMD>Pantran<CR>", { desc = "Open translation window" })
    vim.keymap.set("v", l2("tr"), "<ESC><CMD>'<,'>Pantran<CR>", { desc = "Translate range" })
end

function M.config()
    local pantran = require("pantran")
    local actions = require("pantran.ui.actions")

    pantran.setup({
        default_engine = "google",
        controls = {
            mappings = {
                edit = {
                    n = {
                        ["<C-s>"] = actions.switch_languages,
                    },
                    i = {
                        ["<C-s>"] = actions.switch_languages,
                    },
                },
            },
        },
        engines = {
            google = {
                fallback = {
                    default_target = "ja",
                },
            },
        },
        window = {
            window_config = {
                border = "rounded",
            },
            options = { winhighlight = "" },
        },
    })
end

return M
