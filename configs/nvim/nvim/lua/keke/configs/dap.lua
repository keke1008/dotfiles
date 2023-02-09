local map = require("keke.utils.mapping")

local M = {}

function M.setup()
    map.add_group("<leader>d", "Dap")

    vim.keymap.set("n", "<leader>db", "<CMD>DapToggleBreakpoint<CR>")
    vim.keymap.set("n", "<leader>dv", function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
            if condition then
                require("dap").set_breakpoint(condition)
            end
        end)
    end)
    vim.keymap.set("n", "<leader>dc", "<CMD>DapContinue<CR>")
    vim.keymap.set("n", "<leader>di", "<CMD>DapStepInto<CR>")
    vim.keymap.set("n", "<leader>du", function() require("dap").step_back() end, { desc = "DapStepBack" })
    vim.keymap.set("n", "<leader>do", "<CMD>DapStepOver<CR>")
    vim.keymap.set("n", "<leader>dp", "<CMD>DapStepOut<CR>")
    vim.keymap.set("n", "<leader>dq", "<CMD>DapTerminate<CR>")
    ---@diagnostic disable-next-line: missing-parameter
    vim.keymap.set("n", "<leader>dk", function() require("dapui").eval() end, { desc = "Debug eval" })
    vim.keymap.set("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run the last debug session" })
end

function M.config()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")
    local mason_registry = require("mason-registry")
    local colors = require("tokyonight.colors").setup()

    dapui.setup()
    dap_virtual_text.setup({})

    if mason_registry.is_installed("codelldb") then
        local install_path = mason_registry.get_package("codelldb"):get_install_path()
        local adapter_path = install_path .. "/extension/adapter/codelldb"
        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = adapter_path,
                args = { "--port", "${port}" },
            },
        }
    end

    local function prompt_executable()
        return coroutine.create(function(dap_run_co)
            vim.ui.input(
                { prompt = "Path to executable", default = vim.fn.getcwd() .. "/", completion = "file" },
                function(path) coroutine.resume(dap_run_co, path) end
            )
        end)
    end

    dap.configurations.c = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = prompt_executable,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = dap.configurations.c

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

    vim.api.nvim_set_hl(0, "DebugStopLine", { bg = colors.blue0 })
    vim.api.nvim_set_hl(0, "DebugStopSign", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "DebugBreakpointSign", { fg = colors.red })

    vim.fn.sign_define({
        { name = "DapStopped", text = " ", texthl = "DebugStopSign", linehl = "DebugStopLine" },
        { name = "DapBreakpoint", text = " ", texthl = "DebugBreakpointSign" },
        { name = "DapBreakpointRejected", text = " ", texthl = "DebugBreakpointSign" },
        { name = "DapBreakpointCondition", text = " ", texthl = "DebugBreakpointSign" },
        { name = "DapLogPoint", text = " ", texthl = "DebugBreakpointSign" },
    })
end

return M
