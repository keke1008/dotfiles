local require_all = require'utils'.require_all
local fn = vim.fn

require_all('dap', 'dapui')(function (dap, dapui)
    dapui.setup({})

    dap.listeners.before['event_initialized']['open-ui'] = function(_, _)
        dapui.open()
    end

    vim.cmd[[
        hi DebugBreakpointSign guifg=#cc2222
        hi DebugStopLine guibg=#336611
        hi DebugStopSign guifg=#cccc22
    ]]
    fn.sign_define('DapBreakpoint', { text='', texthl='DebugBreakpointSign' })
    fn.sign_define('DapStopped', { text='', texthl='DebugStopSign', linehl='DebugStopLine' })

    vim.cmd[[ command CloseDapui lua require'dapui'.close() ]]
end)
