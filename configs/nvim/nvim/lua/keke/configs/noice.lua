require("noice").setup({
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
