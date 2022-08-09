local dap = require 'dap'
local dapui = require 'dapui'

local remap = require 'keke.remap'
local fallback = remap.fallback
local set_keymap = remap.set_keymap

---@return boolean
local is_dap_active = function()
    return dap.status() ~= ""
end

---@param lhs string
---@param rhs function
local map = function(lhs, rhs)
    local mode = 'n'
    local opt = { buffer = true, nowait = true }

    local function inner()
        if is_dap_active() then
            rhs()
        else
            fallback(mode, lhs, inner, opt)
        end
    end

    set_keymap(mode, lhs, inner, opt)
end

vim.api.nvim_create_autocmd('BufRead', {
    pattern = '*',
    callback = function()
        map('c', dap.continue)
        map('d', dap.toggle_breakpoint)
        map('i', dap.step_into)
        map('o', dap.step_over)
        map('p', dap.step_out)
        map('r', dap.run_last)
        map('<C-q>', dap.terminate)
        map('K', dapui.eval)
    end
})

set_keymap('n', '<leader>db', dap.toggle_breakpoint)
set_keymap('n', '<leader>dc', dap.continue)


dapui.setup()
dap.listeners.before['event_initialized']['prepare'] = function(_, _)
    ---@diagnostic disable-next-line: missing-parameter
    dapui.open()
end
vim.api.nvim_create_user_command('CloseDapui', dapui.close, {})

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DebugBreakpointSign' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DebugStopSign', linehl = 'DebugStopLine' })
vim.cmd [[
    hi DebugBreakpointSign guifg=#cc2222
    hi DebugStopLine guibg=#336611
    hi DebugStopSign guifg=#cccc22
]]
