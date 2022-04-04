local require_all = require'utils'.require_all
local keymap = require'keymap'
local fn = vim.fn

require_all('dap', 'dapui')(function (dap, dapui)
    dapui.setup({})

    dap.listeners.before['event_initialized']['prepare'] = function(_, _)
        dapui.open()
        keymap.debug_keymap:install()
    end

    dap.listeners.before['event_terminated']['cleanup'] = function(_, _)
        keymap.debug_keymap:uninstall()
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
