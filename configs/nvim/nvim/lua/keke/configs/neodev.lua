local lspconfig = require("lspconfig")
local neodev = require("neodev")
local lsp = require("keke.lsp")

neodev.setup({})

lspconfig.sumneko_lua.setup(lsp.default_config)
