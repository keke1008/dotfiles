local map = require("keke.utils.mapping")
local menu = require("keke.side_menu")

local M = {}

local menu_handle

function M.setup()
    map.add_group("<leader>d", "Dap")

    vim.keymap.set("n", "<leader>db", "<CMD>DapToggleBreakpoint<CR>")
    vim.keymap.set("n", "<leader>dc", "<CMD>DapContinue<CR>")
    vim.keymap.set("n", "<leader>di", "<CMD>DapStepInto<CR>")
    vim.keymap.set("n", "<leader>du", function() require("dap").step_back() end, { desc = "DapStepBack" })
    vim.keymap.set("n", "<leader>do", "<CMD>DapStepOver<CR>")
    vim.keymap.set("n", "<leader>dp", "<CMD>DapStepOut<CR>")
    vim.keymap.set("n", "<leader>dq", "<CMD>DapTerminate<CR>")
    ---@diagnostic disable-next-line: missing-parameter
    vim.keymap.set("n", "<leader>dk", function() require("dapui").eval() end, { desc = "Debug eval" })
    vim.keymap.set("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run the last debug session" })

    menu_handle = menu.register("dap", "d", {
        position = { "left", "right" },
        open = function() require("dapui").open({}) end,
        close = function() require("dapui").close({}) end,
    })
end

function M.config()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")

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

    ---@diagnostic disable-next-line: missing-parameter
    dap_virtual_text.setup()

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

    dap.listeners.before["event_initialized"]["prepare"] = function() menu_handle:open() end

    vim.api.nvim_set_hl(0, "DebugBreakpointSign", { fg = "#cc2222" })
    vim.api.nvim_set_hl(0, "DebugStopLine", { bg = "#336611" })
    vim.api.nvim_set_hl(0, "DebugStopSign", { fg = "#cccc22" })
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DebugBreakpointSign" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DebugStopSign", linehl = "DebugStopLine" })
end

return M
