local null_ls = require("null-ls")
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local mason_registry = require("mason-registry")

local function mason_ready(name)
    return {
        condition = function() return mason_registry.is_installed(name) end,
    }
end

null_ls.setup({
    sources = {
        -- lua
        diagnostics.luacheck.with(mason_ready("luacheck")),
        formatting.stylua.with(mason_ready("stylua")),

        -- js/ts/..
        code_actions.eslint_d.with(mason_ready("eslint_d")),
        formatting.prettierd.with(mason_ready("prettierd")),
    },
})
