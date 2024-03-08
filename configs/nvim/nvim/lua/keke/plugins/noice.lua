return {
    "folke/noice.nvim",
    lazy = false,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    keys = function()
        return {
            {
                "<leader><leader>",
                function()
                    require("notify").dismiss({})
                    vim.cmd("noh")
                end,
                mode = "n",
                desc = "dimiss notifications and highlights"
            },
            {
                "<C-f>",
                function()
                    if not require("noice.lsp").scroll(4) then
                        return "<C-f>"
                    end
                end,
                silent = true,
                expr = true,
                mode = "n",
                desc = "Scroll down noice lsp"
            },
            {
                "<C-b>",
                function()
                    if not require("noice.lsp").scroll(-4) then
                        return "<C-f>"
                    end
                end,
                silent = true,
                expr = true,
                mode = "n",
                desc = "Scroll up noice lsp"
            },
        }
    end,
    opts = {
        commands = {
            history = {
                view = "vsplit",
            },
        },
        views = {
            cmdline_popup = {
                position = { row = "20%" },
                zindex = 100,
            },
            confirm = {
                position = { row = "20%" },
            },
            hover = {
                border = { style = "rounded" },
                position = { row = 2 },
            },
        },
        routes = {
            {
                view = "mini",
                filter = {
                    any = {
                        {
                            event = "msg_show",
                            any = {
                                { kind = "emsg", find = "^E486" },
                                { kind = "emsg", find = "^E37" },
                                { kind = "wmsg", find = "^search hit " },
                                { kind = "",     find = "written$" },
                            },
                        },
                        {
                            event = "notify",
                            kind = "info",
                            find = "^No code actions available",     -- for lspsaga
                        },
                    },
                },
            },
            {
                opts = { skip = true },
                filter = {
                    event = "notify",
                    kind = "warn",
                    find = "^warning: multiple different client offset_encodings",     -- for clangd lsp
                },
            }
        },
    },
}
