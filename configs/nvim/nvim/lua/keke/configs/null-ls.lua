local null_ls = require("null-ls")
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local mason_registry = require("mason-registry")
local lsp = require("keke.lsp")

local function mason_ready(name)
    return {
        condition = function() return mason_registry.is_installed(name) end,
    }
end

null_ls.setup({
    on_attach = lsp.on_attach,
    sources = {
        -- lua
        diagnostics.luacheck.with(mason_ready("luacheck")),
        formatting.stylua.with(mason_ready("stylua")),

        -- js/ts/..
        code_actions.eslint_d.with(mason_ready("eslint_d")),
        formatting.prettierd.with(mason_ready("prettierd")),
    },
})

local function format()
    local null_ls_client = vim.lsp.get_active_clients({
        name = "null-ls",
        buffer = vim.api.nvim_get_current_buf,
    })[1]
    if null_ls_client and null_ls_client.supports_method("textDocument/formatting") then
        vim.lsp.buf.format({ id = null_ls_client.id })
    else
        vim.lsp.buf.format({})
    end
end

local augroup_name = "format_on_save"

local function register_format_on_save()
    local augroup = vim.api.nvim_create_augroup(augroup_name, {})
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        pattern = "*",
        callback = format,
    })
end

local function unregister_format_on_save() vim.api.nvim_del_augroup_by_name(augroup_name) end

register_format_on_save()

vim.api.nvim_create_user_command("W", function(opt)
    unregister_format_on_save()
    vim.cmd(opt.bang and "w!" or "w")
    register_format_on_save()
end, { bang = true })
