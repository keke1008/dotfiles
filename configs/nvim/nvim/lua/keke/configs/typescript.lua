local util = require("lspconfig.util")
local typescript = require("typescript")

local lsp = require("keke.utils.lsp")

local is_deno_project = util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd())
if is_deno_project then return end

typescript.setup({
    server = lsp.extend_default_config({
        root_dir = util.find_package_json_ancestor,
    }),
})
