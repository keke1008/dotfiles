local drawer = require("drawer")

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "rcarriga/nvim-dap-ui",            config = true },
            { "theHamsta/nvim-dap-virtual-text", config = true },
            { "mxsdev/nvim-dap-vscode-js",       opts = { adapters = { "pwa-node" } } },
        },
        init = function()
            drawer.register({
                name = "dap",
                positions = { "left", "bottom" },
                open = function() require("dapui").open() end,
                close = function() require("dapui").close() end,
            })
        end,
        cmd = "Dap",
        keys = function()
            local function conditional()
                vim.ui.input({ prompt = "Condition: " }, function(condition)
                    if condition then
                        require("dap").set_breakpoint(condition)
                    end
                end)
            end

            return {
                { drawer.with_prefix_key("d"), function() drawer.open("dap") end,        mode = "n", desc = "open dap" },
                { "<leader>db",                "<CMD>DapToggleBreakpoint<CR>",           mode = "n" },
                { "<leader>dv",                conditional,                              mode = "n", desc = "Set condition breakpoint" },
                { "<leader>dc",                "<CMD>DapContinue<CR>",                   mode = "n" },
                { "<leader>di",                "<CMD>DapStepInto<CR>",                   mode = "n" },
                { "<leader>do",                "<CMD>DapStepOver<CR>",                   mode = "n" },
                { "<leader>dp",                "<CMD>DapStepOut<CR>",                    mode = "n" },
                { "<leader>dq",                "<CMD>DapTerminate<CR>",                  mode = "n" },
                { "<leader>dk",                function() require("dapui").eval() end,   mode = "n", desc = "Debug eval" },
                { "<leader>dl",                function() require("dap").run_last() end, mode = "n", desc = "Run the last debug session" },
            }
        end,
        config = function()
            local dap = require("dap")
            local mason_registry = require("mason-registry")
            local colors = require("tokyonight.colors").setup()

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

            dap.configurations.typescript = {
                {
                    name = "tsx",
                    type = "pwa-node",
                    request = "launch",
                    program = prompt_executable,
                    cwd = "${workspaceFolder}",
                    runtimeExecutable = "${workspaceFolder}/node_modules/.bin/tsx",
                    sourceMaps = true,
                    protocol = "inspector",
                    console = "integratedTerminal",
                    skipFiles = { "<node_internals>/**" },
                },
            }

            dap.listeners.after.event_initialized["dapui_config"] = function() drawer.push("dap") end
            dap.listeners.before.event_terminated["dapui_config"] = function() drawer.close_by_name("dap") end
            dap.listeners.before.event_exited["dapui_config"] = function() drawer.close_by_name("dap") end

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
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
            local dap_python = require("dap-python")
            local mason_registry = require("mason-registry")

            local installed, debugpy = pcall(mason_registry.get_package, "debugpy")
            if not installed then
                vim.notify("`debugpy` in not installed.", vim.log.levels.INFO)
                return
            end

            local debugpy_path = debugpy:get_install_path()
            local python_path = debugpy_path .. "/venv/bin/python"
            dap_python.setup(python_path)

            local debug_opts = {
                test_runner = "unittest",
            }

            vim.api.nvim_create_user_command("DebugpyRunner", function(e) debug_opts.test_runner = e.args end, {
                nargs = 1,
                complete = function() return { "unittest", "pytest", "django" } end,
            })

            vim.keymap.set("n", "<leader>dm", function() dap_python.test_method(debug_opts) end,
                { desc = "Debug test method" })
            vim.keymap.set("n", "<leader>da", function() dap_python.test_class(debug_opts) end,
                { desc = "Debug test class" })
        end,
    }
}
