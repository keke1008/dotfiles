local M = {}

function M.setup()
    local remap = vim.keymap.set
    local menu = require("keke.side_menu")

    remap("n", "<leader>tt", "<CMD>Trouble<CR>")
    remap("n", "<leader>td", "<CMD>Trouble lsp_definitions<CR>")
    remap("n", "<leader>tD", "<CMD>Trouble lsp_type_definitions<CR>")
    remap("n", "<leader>tr", "<CMD>Trouble lsp_references<CR>")
    remap("n", "<leader>ti", "<CMD>Trouble lsp_implementations<CR>")
    remap("n", "<leader>tq", "<CMD>Trouble quickfix<CR>")
    remap("n", "<leader>tl", "<CMD>Trouble loclist<CR>")
    remap("n", "<leader>tw", "<CMD>Trouble workspace_diagnostics<CR>")

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
