local null_ls = require 'null-ls'
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local mason_registry = require'mason-registry'

local function mason_ready(name)
    return {
        condition = function ()
            return mason_registry.is_installed(name)
        end
    }
end

null_ls.setup {
    sources = {
        diagnostics.luacheck.with(mason_ready 'luacheck'),
        formatting.stylua.with(mason_ready 'stylua'),
    }
}
