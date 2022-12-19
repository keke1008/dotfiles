local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local root_pattern = require("lspconfig.util").root_pattern

local lsp = require("keke.lsp")

mason.setup()
mason_lspconfig.setup()

---@param name string
---@return string?
local function if_exists(name)
    local exists = vim.fn.glob(name)
    return exists ~= "" and exists or nil
end

mason_lspconfig.setup_handlers({
    function(server_name) lspconfig[server_name].setup(lsp.default_config) end,
    ["denols"] = function(_)
        lspconfig.denols.setup(lsp.extend_default_config({
            root_dir = root_pattern("deno.json", "deno.jsonc"),
            settings = {
                deno = {
                    enable = true,
                    lint = true,
                    config = if_exists("./deno.json*"),
                    importMap = if_exists("./import_map.json"),
                },
            },
        }))
    end,
    ["sumneko_lua"] = function(_)
        -- neodev.nvim
    end,
    ["clangd"] = function(_)
        -- clangd_extensions.nvim
    end,
    ["tsserver"] = function(_)
        -- typescript.nvim
    end,
})
