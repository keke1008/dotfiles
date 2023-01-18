local noice = require("noice")
local notify = require("notify")
local remap = vim.keymap.set

noice.setup({
    routes = {
        {
            view = "mini",
            filter = { event = "msg_show", kind = "" },
        },
        {
            view = "mini",
            filter = { event = "msg_show", kind = "wmsg", find = "^search hit" },
        },
        {
            view = "mini",
            filter = { event = "msg_show", kind = "emsg", find = "^E486" },
        },
    },
})

remap("n", "<leader>nh", "Noice history")
remap("n", "<leader>nl", "Noice last")
remap("n", "<leader>nt", "Noice telescope")
remap("n", "<leader>nn", notify.dismiss)
