local map = require("keke.utils.mapping")

local M = {}

function M.setup() vim.keymap.set("n", map.l2("te"), "<CMD>ToggleTerm<CR>") end

function M.config()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
        direction = "float",
        float_opts = {
            border = "rounded",
        },
        highlights = {
            FloatBorder = { link = "FloatBorder" },
        },
    })
end

return M
