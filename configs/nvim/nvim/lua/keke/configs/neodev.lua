local lspconfig = require("lspconfig")
local neodev = require("neodev")
local lsp = require("keke.utils.lsp")

neodev.setup({})

lspconfig.lua_ls.setup(lsp.default_config)
