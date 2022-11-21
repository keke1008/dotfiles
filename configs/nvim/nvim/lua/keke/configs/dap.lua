local dap = require("dap")
local dapui = require("dapui")
local menu = require("keke.side_menu")
local remap = vim.keymap.set

local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = codelldb_path,
        args = { "--port", "${port}" },
    },
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
    },
}

remap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
remap("n", "<leader>dc", dap.continue, { desc = "Debug continue" })
remap("n", "<leader>du", dap.step_back, { desc = "Debug step back" })
remap("n", "<leader>di", dap.step_into, { desc = "Debug step into" })
remap("n", "<leader>do", dap.step_over, { desc = "Debug step over" })
remap("n", "<leader>dp", dap.step_out, { desc = "Debug step out" })
remap("n", "<leader>dq", dap.terminate, { desc = "Debug terminate" })
remap("n", "<leader>dQ", function()
    dap.terminate()
    dapui.close({})
end)
remap("n", "<leader>dk", dapui.eval, { desc = "Debug eval" })

dapui.setup({
    layouts = {
        {
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size = 40,
            position = "left",
        },
        {
            elements = { "repl", "console" },
            size = 0.3,
            position = "right",
        },
    },
})

local handle = menu.register("dap", "d", {
    position = { "left", "right" },
    open = dapui.open,
    close = dapui.close,
})

dap.listeners.before["event_initialized"]["prepare"] = function() handle:open() end

vim.api.nvim_set_hl(0, "DebugBreakpointSign", { fg = "#cc2222" })
vim.api.nvim_set_hl(0, "DebugStopLine", { bg = "#336611" })
vim.api.nvim_set_hl(0, "DebugStopSign", { fg = "#cccc22" })
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DebugBreakpointSign" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DebugStopSign", linehl = "DebugStopLine" })
