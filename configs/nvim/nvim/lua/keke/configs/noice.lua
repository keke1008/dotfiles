local noice = require("noice")
local notify = require("notify")
local map = require("keke.utils.mapping")

noice.setup({
    commands = {
        history = {
            view = "vsplit",
        },
    },
    views = {
        cmdline_popup = {
            position = {
                row = "20%",
            },
            zindex = 100,
        },
        confirm = {
            position = {
                row = "20%",
            },
        },
        hover = {
            border = {
                style = "rounded",
            },
            position = { row = 2 },
        },
    },
    routes = {
        {
            view = "mini",
            filter = {
                event = "msg_show",
                any = {
                    { kind = "emsg", find = "^E486" },
                    { kind = "emsg", find = "^E37" },
                    { kind = "wmsg", find = "^search hit " },
                    { kind = "", find = "written$" },
                },
            },
        },
        {
            view = "cmdline_output",
            filter = {
                cmdline = "^:",
                error = false,
                warning = false,
                ["not"] = {
                    any = {
                        kind = { "confirm", "confirm_sub", "return_prompt" },
                        { kind = "", find = "substitutions on %d+ lines$" },
                        { kind = "echo", find = "substitutions on %d+ lines$" },
                    },
                },
            },
        },
    },
})

map.add_group("<leader>n", "Noice")

vim.keymap.set("n", "<leader>nh", "<CMD>Noice history<CR>")
vim.keymap.set("n", "<leader>nl", "<CMD>Noice last<CR>")
vim.keymap.set("n", "<leader>nt", "<CMD>Noice telescope<CR>")
vim.keymap.set("n", "<leader><leader>", function()
    notify.dismiss({})
    vim.cmd([[noh]])
end, { desc = "dimiss notifications and highlights" })

vim.keymap.set({ "n", "i" }, "<C-f>", function()
    if not require("noice.lsp").scroll(4) then
        return "<C-f>"
    end
end, { silent = true, expr = true, desc = "Scroll down noice lsp" })

vim.keymap.set({ "n", "i" }, "<C-b>", function()
    if not require("noice.lsp").scroll(-4) then
        return "<C-b>"
    end
end, { silent = true, expr = true, desc = "Scroll up noice lsp" })
