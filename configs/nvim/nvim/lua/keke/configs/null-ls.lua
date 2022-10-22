local null_ls = require 'null-ls'

local function executable(cmd)
    return {
        condition = function()
            return vim.fn.executable(cmd) == 1
        end
    }
end

null_ls.setup {
    sources = {
        null_ls.builtins.diagnostics.luacheck.with(executable 'luacheck'),
    }
}
