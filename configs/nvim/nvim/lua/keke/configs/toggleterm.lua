local remap = vim.keymap.set
local l2 = require("keke.keymap").l2

local M = {}

function M.setup() remap("n", l2("te"), "<CMD>ToggleTerm direction=float<CR>") end

function M.config()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
        on_create = function(term)
            remap("n", "<Esc>", "<CMD>ToggleTerm<CR>", {
                buffer = term.bufnr,
                desc = "Close terminal",
            })
        end,
    })
end

return M
