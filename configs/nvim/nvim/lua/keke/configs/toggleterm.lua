local remap = vim.keymap.set
local l2 = require("keke.keymap").l2

local M = {}

function M.setup() remap("n", l2("te"), "<CMD>ToggleTerm<CR>") end

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
        on_create = function(term)
            remap("n", "<Esc>", "<CMD>ToggleTerm<CR>", {
                buffer = term.bufnr,
                desc = "Close terminal",
            })
        end,
    })
end

return M
