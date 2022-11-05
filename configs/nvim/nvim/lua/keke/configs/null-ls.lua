local null_ls = require("null-ls")
local lsp = require("keke.lsp")

local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

---@param name string
local function executable(name)
    return {
        condition = function() return vim.fn.executable(name) == 1 end,
    }
end

null_ls.setup({
    on_attach = lsp.on_attach,
    sources = {
        -- lua
        diagnostics.luacheck.with(executable("luacheck")),
        formatting.stylua.with(executable("stylua")),

        -- js/ts/..
        code_actions.eslint_d.with(executable("eslint_d")),
        formatting.prettierd.with(executable("prettierd")),

        -- python
        diagnostics.flake8.with(executable("flake8")),
        diagnostics.pylint.with(executable("pylint")),
        diagnostics.mypy.with(executable("mypy")),
        diagnostics.vulture.with(executable("vulture")),
        formatting.black.with(executable("black")),
        formatting.isort.with(executable("isort")),
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

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = format,
})

vim.api.nvim_create_user_command("W", function(opt)
    local cmd = opt.bang and "w!" or "w"
    vim.cmd("noautocmd " .. cmd)
end, { bang = true })
