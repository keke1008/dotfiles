local M = {}

M.installer = function(debugger_name)
    return require('debugger-installer.languages.' .. debugger_name)
end

return M
