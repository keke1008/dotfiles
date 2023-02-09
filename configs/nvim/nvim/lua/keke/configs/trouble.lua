local map = require("keke.utils.mapping")
local menu = require("keke.side_menu")

local M = {}

function M.setup()
    map.add_group("<leader>t", "Trouble")

    vim.keymap.set("n", "<leader>tt", "<CMD>Trouble<CR>")
    vim.keymap.set("n", "<leader>td", "<CMD>Trouble lsp_definitions<CR>")
    vim.keymap.set("n", "<leader>tD", "<CMD>Trouble lsp_type_definitions<CR>")
    vim.keymap.set("n", "<leader>tr", "<CMD>Trouble lsp_references<CR>")
    vim.keymap.set("n", "<leader>ti", "<CMD>Trouble lsp_implementations<CR>")
    vim.keymap.set("n", "<leader>tq", "<CMD>Trouble quickfix<CR>")
    vim.keymap.set("n", "<leader>tl", "<CMD>Trouble loclist<CR>")
    vim.keymap.set("n", "<leader>tw", "<CMD>Trouble workspace_diagnostics<CR>")

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
