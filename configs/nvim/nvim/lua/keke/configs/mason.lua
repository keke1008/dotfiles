local neoconf = require("neoconf")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local mason_null_ls = require("mason-null-ls")
local mason_null_ls_automatic_setup = require("mason-null-ls.automatic_setup")
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

mason_null_ls.setup()

---@param condition fun(utils: any): boolean
local function setup_null_ls_with_condition(condition)
    return function(source_name, methods)
        if null_ls.is_registered(source_name) then return end
        for _, method in ipairs(methods) do
            null_ls.builtins[method][source_name].with({ condition = condition })
        end
    end
end

---@param name string
---@return boolean
local function exists(name) return vim.fn.exists(name) == 1 end

local eslint_root_files = {
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    "package.json",
}

mason_null_ls.setup_handlers({
    mason_null_ls_automatic_setup,
    eslint = setup_null_ls_with_condition(
        function(utils) return not exists("eslint_d") and utils.root_has_file(eslint_root_files) end
    ),
    eslint_d = setup_null_ls_with_condition(function(utils) return utils.root_has_file(eslint_root_files) end),
    prettier = setup_null_ls_with_condition(function() return exists("prettierd") end),
})

null_ls.setup({})
