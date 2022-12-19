local lspconfig = require("lspconfig")
local neodev = require("neodev")
local lsp = require("keke.lsp")

neodev.setup({})

lspconfig.sumneko_lua.setup(lsp.extend_default_config({
    settings = {
        Lua = {
            completion = {
                callSnnippet = "Replace",
            },
        },
    },
}))
