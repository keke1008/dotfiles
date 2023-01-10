local clangd_extensions = require("clangd_extensions")
local lsp = require("keke.utils.lsp")

clangd_extensions.setup({
    server = lsp.default_config,
})
