local noice = require("noice")
local notify = require("notify")
local map = require("keke.utils.mapping")

noice.setup({
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
        vsplit = {
            size = {
                max_width = "50%",
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
                kind = "emsg",
                any = {
                    { find = "^E486" },
                    { find = "^E37" },
                },
            },
        },
        {
            view = "mini",
            filter = {
                any = {
                    { event = "msg_show", kind = { "", "echo", "echomsg", "wmsg" } },
                    { event = "notify", error = false, warning = false },
                },
            },
        },
        {
            view = "cmdline_output",
            filter = {
                cmdline = "^:",
                error = false,
                warning = false,
                ["not"] = { kind = { "confirm", "confirm_sub", "return_prompt" } },
            },
        },
        {
            view = "vsplit",
            filter = { min_height = 10, ["not"] = { event = "lsp" } },
        },
    },
})

map.add_group("<leader>n", "Noice")

vim.keymap.set("n", "<leader>nh", "<CMD>Noice history<CR>")
vim.keymap.set("n", "<leader>nl", "<CMD>Noice last<CR>")
vim.keymap.set("n", "<leader>nt", "<CMD>Noice telescope<CR>")
vim.keymap.set("n", "<leader>nn", notify.dismiss, { desc = "dimiss notifications" })
