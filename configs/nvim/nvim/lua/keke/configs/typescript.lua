local root_pattern = require("lspconfig.util").root_pattern
local typescript = require("typescript")

local lsp = require("keke.lsp")

typescript.setup({
    server = lsp.extend_default_config({
        root_dir = root_pattern("package.json"),
    }),
})
