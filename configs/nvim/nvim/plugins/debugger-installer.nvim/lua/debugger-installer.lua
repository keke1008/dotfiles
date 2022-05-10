local api = vim.api
local languages = require'debugger-installer.languages'

local debuggers = { 'java' }

local function completion()
    return debuggers
end

local M = {}

M.setup = function()
    api.nvim_create_user_command(
        'DebuggerInstall',
        function (opts)
            local debugger_name = opts.args:match('%S+')
            languages.installer(debugger_name).install()
        end,
        {
            nargs = 1,
            complete = completion,
            bar = true
        }
    )
end

return M
