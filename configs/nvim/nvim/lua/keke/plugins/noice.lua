return {
    {
        "rcarriga/nvim-notify",
        opts = {
            render = "wrapped-compact",
            stages = "static",
            fps = 5,
        },
    },
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        lazy = false,
        keys = function()
            return {
                {
                    "<leader><leader>",
                    function()
                        require("notify").dismiss({ pending = true, silent = true })
                        vim.cmd("noh")
                    end,
                    mode = "n",
                    desc = "dimiss notifications and highlights",
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
                    desc = "Scroll down noice lsp",
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
                    desc = "Scroll up noice lsp",
                },
            }
        end,
        config = function()
            require("noice").setup({
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
                                { warning = true },
                                { event = "notify", kind = "info" },
                                {
                                    event = "msg_show",
                                    any = {
                                        { kind = "emsg", find = "^E486" },
                                        { kind = "emsg", find = "^E37" },
                                        { kind = "", find = "written$" },
                                    },
                                },
                            },
                        },
                    },
                },
            })
        end,
    },
}
