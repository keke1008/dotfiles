local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local lspconfig_util = require("lspconfig.util")
local path = lspconfig_util.path
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsp_signature = require("lsp_signature")

local set_keymap = require("keke.remap").set_keymap

lsp_signature.setup({
    bind = true,
    handler_opts = {
        border = "rounded",
    },
})

---@param builtin string
---@param window_size? 'small'
---@return function
local telescope_open = function(builtin, window_size)
    local layout_config
    if window_size == "small" then
        layout_config = { width = 0.4, height = 0.2 }
    else
        layout_config = { width = 0.5, height = 0.5 }
    end
    return function() require("telescope.builtin")[builtin]({ layout_strategy = "cursor", layout_config = layout_config }) end
end

---@param lhs string
---@param rhs string|function
local nmap = function(lhs, rhs) set_keymap("n", lhs, rhs) end

---@param lhs string
---@param builtin string
---@param window_size? 'small'
local telescope_map = function(lhs, builtin, window_size) nmap(lhs, telescope_open(builtin, window_size)) end

telescope_map("gd", "lsp_definitions")
telescope_map("gi", "lsp_implementations")
telescope_map("gr", "lsp_references")
nmap("gD", vim.lsp.buf.declaration)
nmap("[g", vim.diagnostic.goto_prev)
nmap("]g", vim.diagnostic.goto_next)
nmap("<leader>rn", vim.lsp.buf.rename)
telescope_map("<leader>ac", "lsp_code_actions", "small")
nmap("<leader>qf", vim.lsp.buf.code_action)
nmap("<C-k>", function() vim.diagnostic.open_float({ scope = "cursor" }) end)
nmap("K", function()
    if vim.bo.filetype == "vim" or vim.bo.filetype == "help" then
        ---@diagnostic disable-next-line: missing-parameter
        vim.cmd("help " .. vim.fn.expand("<cword>"))
    else
        vim.lsp.buf.hover()
    end
end)

local root_pattern = require("lspconfig.util").root_pattern

local capabilities = cmp_nvim_lsp.default_capabilities()
local on_attach = function() require("lsp_signature").on_attach() end
local default_settings = {
    capabilities = capabilities,
    on_attach = on_attach,
}

mason.setup()

---@param name string
---@return string?
local function if_exists(name)
    local exists = vim.fn.glob(name)
    return exists ~= "" and exists or nil
end

mason_lspconfig.setup_handlers({
    function(server_name) lspconfig[server_name].setup(default_settings) end,
    ["denols"] = function()
        lspconfig.denols.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = root_pattern("deno.json", "deno.jsonc"),
            settings = {
                deno = {
                    enable = true,
                    lint = true,
                    config = if_exists("./deno.json*"),
                    importMap = if_exists("./import_map.json"),
                },
            },
        })
    end,
    ["tsserver"] = function()
        lspconfig.tsserver.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = root_pattern("package.json"),
        })
    end,
    ["sumneko_lua"] = function()
        require("neodev").setup({})
        lspconfig.sumneko_lua.setup({
            settings = {
                Lua = {
                    completion = {
                        callSnnippet = "Replace",
                    },
                },
            },
        })
    end,
})
