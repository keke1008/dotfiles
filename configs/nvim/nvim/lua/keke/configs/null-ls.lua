local null_ls = require("null-ls")
local lsp = require("keke.lsp")

---@class Condition
---@field condition fun(): boolean
---@operator mul(Condition): Condition
local Condition = {}
local mt = {
    __mul = function(a, b)
        return Condition.new(function() return a.condition() and b.condition() end)
    end,
}

---@param f fun(): boolean
---@return Condition
function Condition.new(f) return setmetatable({ condition = f }, mt) end

local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local code_action = null_ls.builtins.code_actions

---@param name string
---@return Condition
local function exists(name)
    return Condition.new(function() return vim.fn.executable(name) == 1 end)
end

local function not_exists(name)
    return Condition.new(function() return vim.fn.executable(name) ~= 1 end)
end

null_ls.setup({
    on_attach = lsp.on_attach,
    sources = {
        -- lua
        diagnostics.luacheck.with(exists("luacheck")),
        formatting.stylua.with(exists("stylua")),

        -- js/ts/..
        diagnostics.eslint.with(exists("eslint") * not_exists("eslint_d")),
        diagnostics.eslint_d.with(exists("eslint_d")),
        formatting.prettier.with(exists("prettier") * not_exists("prettierd")),
        formatting.prettierd.with(exists("prettierd")),

        -- python
        diagnostics.flake8.with(exists("flake8")),
        diagnostics.pylint.with(exists("pylint")),
        diagnostics.mypy.with(exists("mypy")),
        diagnostics.vulture.with(exists("vulture")),
        formatting.black.with(exists("black")),
        formatting.isort.with(exists("isort")),
        formatting.autopep8.with(exists("autopep8")),

        -- shell
        diagnostics.shellcheck.with(exists("shellcheck")),
        code_action.shellcheck.with(exists("shellcheck")),

        -- c
        diagnostics.cpplint.with(exists("cpplint")),
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
