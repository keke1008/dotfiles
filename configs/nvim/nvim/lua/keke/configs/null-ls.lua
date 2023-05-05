local null_ls = require("null-ls")
local utils = require("null-ls.utils")

---@param cmd string
---@return boolean
local function executable(cmd) return vim.fn.executable(cmd) == 1 end

local PREFER_LOCAL_NODE_BIN = "node_modules/.bin"

---@enum SourceMethod
local METHOD = {
    code_actions = "code_actions",
    completion = "completion",
    diagnostics = "diagnostics",
    formatting = "formatting",
    hover = "hover",
}

---@class Source
---@field method SourceMethod | SourceMethod[]
---@field command? string
---@field disable? fun(): boolean
---@field prefer_local? string

---@param name string
---@param source Source
---@return unknown[]: list of null-ls sources
local function generate_source(name, source)
    local command = source.command or name
    local disable = source.disable or function() return false end
    local option = {
        condition = function() return executable(command) and not disable() end,
        prefer_local = source.prefer_local,
    }

    return vim.tbl_map(
        function(method) return null_ls.builtins[method][name].with(option) end,
        type(source.method) == "table" and source.method or { source.method } --[=[@as SourceMethod[]]=]
    )
end

---@type table<string, Source>
local register_source_list = {
    -- Lua
    stylua = { method = METHOD.formatting },
    luacheck = { method = METHOD.diagnostics },

    -- JavaScript/TypeScript/..
    eslint = {
        method = { METHOD.diagnostics, METHOD.code_actions },
        prefer_local = PREFER_LOCAL_NODE_BIN,
        disable = function() return executable("eslint_d") end,
    },
    eslint_d = {
        method = { METHOD.diagnostics, METHOD.code_actions },
        prefer_local = PREFER_LOCAL_NODE_BIN,
    },
    prettier = {
        method = METHOD.formatting,
        prefer_local = PREFER_LOCAL_NODE_BIN,
        disable = function() return executable("prettierd") end,
    },
    prettierd = {
        method = METHOD.formatting,
        prefer_local = PREFER_LOCAL_NODE_BIN,
    },

    -- Python
    flake8 = { method = METHOD.diagnostics },
    pylint = { method = METHOD.diagnostics },
    mypy = { method = METHOD.diagnostics },
    vulture = { method = METHOD.diagnostics },
    black = { method = METHOD.formatting },
    isort = { method = METHOD.formatting },
    autopep8 = { method = METHOD.formatting },

    -- Ruby
    rubocop = { method = { METHOD.diagnostics, METHOD.formatting } },
    erb_lint = {
        method = { METHOD.diagnostics, METHOD.formatting },
        command = "erblint",
    },

    -- Shell Script
    shellcheck = { method = { METHOD.code_actions, METHOD.diagnostics } },

    -- C/C++
    cpplint = { method = METHOD.diagnostics },
}

local sources = {}
for name, register_source in pairs(register_source_list) do
    vim.list_extend(sources, generate_source(name, register_source))
end

null_ls.setup({
    sources = sources,
    root_dir = utils.root_pattern(".null-ls-root", "neoconf.json", ".git", "Makefile"),
})
