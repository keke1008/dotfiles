local neoconf = require("neoconf")

return {
    -- Since `ruby_lsp` does not support `workspace/didChangeConfiguration`,
    -- workspace configuration must be sent at initialization time.
    -- https://github.com/Shopify/ruby-lsp/issues/205
    init_options = neoconf.get("lspconfig.ruby_lsp"),
}
