local M = {}

local menu_handle

function M.setup()
    local remap = vim.keymap.set
    local menu = require("keke.side_menu")

    remap("n", "<leader>db", "<CMD>DapToggleBreakpoint<CR>")
    remap("n", "<leader>dc", "<CMD>DapContinue<CR>")
    remap("n", "<leader>di", "<CMD>DapStepInto<CR>")
    remap("n", "<leader>du", function() require("dap").step_back() end, { desc = "DapStepBack" })
    remap("n", "<leader>do", "<CMD>DapStepOver<CR>")
    remap("n", "<leader>dp", "<CMD>DapStepOut<CR>")
    remap("n", "<leader>dq", "<CMD>DapTerminate<CR>")
    remap("n", "<leader>dQ", function()
        require("dap").terminate()
        require("dapui").close({})
    end, { desc = "Close Dap" })
    ---@diagnostic disable-next-line: missing-parameter
    remap("n", "<leader>dk", function() require("dapui").eval() end, { desc = "Debug eval" })

    menu_handle = menu.register("dap", "d", {
        position = { "left", "right" },
        open = function() require("dapui").open({}) end,
        close = function() require("dapui").close({}) end,
    })
end

function M.config()
    local dap = require("dap")
    local dapui = require("dapui")

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

    dap.listeners.before["event_initialized"]["prepare"] = function() menu_handle:open() end

    vim.api.nvim_set_hl(0, "DebugBreakpointSign", { fg = "#cc2222" })
    vim.api.nvim_set_hl(0, "DebugStopLine", { bg = "#336611" })
    vim.api.nvim_set_hl(0, "DebugStopSign", { fg = "#cccc22" })
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DebugBreakpointSign" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DebugStopSign", linehl = "DebugStopLine" })
end

return M
