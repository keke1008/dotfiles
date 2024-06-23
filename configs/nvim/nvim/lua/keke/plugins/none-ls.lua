return {
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local mason_null_ls = require("mason-null-ls")
            local null_ls = require("null-ls")

            ---@diagnostic disable-next-line: missing-fields
            mason_null_ls.setup({
                handlers = {},
            })

            null_ls.setup({
                sources = {},
            })
        end,
    },
}
