local dap = require 'dap'
local dapui = require 'dapui'

local remap = require 'keke.remap'
local fallback = remap.fallback
local set_keymap = remap.set_keymap
local sidemenu = require 'keke.sidemenu'

local extension_path = vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'

dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        command = codelldb_path,
        args = { "--port", "${port}" },
    }
}

dap.configurations.cpp = { {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
} }

---@return boolean
local is_dap_active = function()
    return dap.status() ~= ''
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



local menu = sidemenu.register('d', {
    name = "dapui",
    open = dapui.open,
    close = dapui.close
})

dap.listeners.before['event_initialized']['prepare'] = function(_, _)
    menu:open()
end
vim.api.nvim_create_user_command('CloseDapui', dapui.close, {})


vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DebugBreakpointSign' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DebugStopSign', linehl = 'DebugStopLine' })
vim.api.nvim_set_hl(0, 'DebugBreakpointSign', { fg = '#cc2222' })
vim.api.nvim_set_hl(0, 'DebugStopLine', { bg = '#336611' })
vim.api.nvim_set_hl(0, 'DebugStopSign', { fg = '#cccc22' })

dapui.setup({
    layouts = {
        {
            elements = {
                { id = 'scopes', size = 0.25 },
                'breakpoints',
                'stacks',
                'watches',
            },
            size = 40,
            position = 'left',
        },
        {
            elements = {
                'repl',
                'console',
            },
            size = 80,
            position = 'right',
        },
    }
})
