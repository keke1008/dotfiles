local neoconf = require("neoconf")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local root_pattern = require("lspconfig.util").root_pattern
local lsp = require("keke.utils.lsp")

neoconf.setup({})
mason.setup()
mason_lspconfig.setup()

mason_lspconfig.setup_handlers({
    function(server_name) lspconfig[server_name].setup(lsp.default_config) end,
    ["denols"] = function(_)
        lspconfig.denols.setup(lsp.extend_default_config({
            root_dir = root_pattern("deno.json", "deno.jsonc"),
        }))
    end,
    ["lua_ls"] = function(_)
        -- neodev.nvim
    end,
    ["clangd"] = function(_)
        -- clangd_extensions.nvim
    end,
    ["tsserver"] = function(_)
        -- typescript.nvim
    end,
})
