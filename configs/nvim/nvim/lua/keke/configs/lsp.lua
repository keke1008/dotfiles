local ok, mason, mason_lspconfig, lspconfig, lspconfig_util, lsp_signature, saga, lsp = pcall(
    function()
        return require("mason"),
            require("mason-lspconfig"),
            require("lspconfig"),
            require("lspconfig.util"),
            require("lsp_signature"),
            require("lspsaga"),
            require("keke.lsp")
    end
)
if not ok then return end
local root_pattern = lspconfig_util.root_pattern

mason.setup()
mason_lspconfig.setup()

lsp_signature.setup({
    bind = true,
    handler_opts = {
        border = "rounded",
    },
})

saga.init_lsp_saga({
    saga_winblend = 30,
    code_action_lightbulb = {
        sign = false,
    },
    finder_action_keys = {
        open = "e",
        vsplit = "v",
        split = "i",
        tabe = "t",
        quit = "<ESC>",
    },
    definition_action_keys = {
        edit = "<leader>:e",
        vsplit = "<leader>:v",
        split = "<leader>:s",
        tabe = "<leader>:t",
    },
    rename_action_quit = "<C-c>",
})

---@param name string
---@return string?
local function if_exists(name)
    local exists = vim.fn.glob(name)
    return exists ~= "" and exists or nil
end

mason_lspconfig.setup_handlers({
    function(server_name) lspconfig[server_name].setup(lsp.default_config) end,
    ["denols"] = function()
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
    ["tsserver"] = function()
        lspconfig.tsserver.setup(lsp.extend_default_config({
            root_dir = root_pattern("package.json"),
        }))
    end,
    ["sumneko_lua"] = function()
        require("neodev").setup({})
        lspconfig.sumneko_lua.setup(lsp.extend_default_config({
            settings = {
                Lua = {
                    completion = {
                        callSnnippet = "Replace",
                    },
                },
            },
        }))
    end,
})
