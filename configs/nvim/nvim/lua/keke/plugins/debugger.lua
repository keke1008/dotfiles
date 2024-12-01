local drawer = require("drawer")

return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            handlers = {},
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "mxsdev/nvim-dap-vscode-js", opts = { adapters = { "pwa-node" } } },
        },
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
                { "<leader>db", "<CMD>DapToggleBreakpoint<CR>", mode = "n" },
                { "<leader>dv", conditional, mode = "n", desc = "Set condition breakpoint" },
                { "<leader>dc", "<CMD>DapContinue<CR>", mode = "n" },
                { "<leader>di", "<CMD>DapStepInto<CR>", mode = "n" },
                { "<leader>do", "<CMD>DapStepOver<CR>", mode = "n" },
                { "<leader>dp", "<CMD>DapStepOut<CR>", mode = "n" },
                { "<leader>dq", "<CMD>DapTerminate<CR>", mode = "n" },
                {
                    "<leader>dl",
                    function()
                        require("dap").run_last()
                    end,
                    mode = "n",
                    desc = "Run last debug session",
                },
            }
        end,
        config = function()
            local dap = require("dap")
            local colors = require("tokyonight.colors").setup()

            local function prompt_executable()
                return coroutine.create(function(dap_run_co)
                    vim.ui.input(
                        { prompt = "Path to executable", default = vim.fn.getcwd() .. "/", completion = "file" },
                        function(path)
                            coroutine.resume(dap_run_co, path)
                        end
                    )
                end)
            end

            local function append_configuration(lang, config)
                dap.configurations[lang] = dap.configurations[lang] or {}
                table.insert(dap.configurations[lang], config)
            end

            local codelldb_configuration = {
                name = "Launch executable file with codelldb",
                type = "codelldb",
                request = "launch",
                program = prompt_executable,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            }
            append_configuration("c", codelldb_configuration)
            append_configuration("cpp", codelldb_configuration)
            append_configuration("rust", codelldb_configuration)
            append_configuration("typescript", {
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
            })

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

            dap.listeners.after.event_initialized["dapui_config"] = function()
                drawer.push("dap")
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                drawer.close_by_name("dap")
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                drawer.close_by_name("dap")
            end

            -- load virtual-text plugin
            dap.listeners.before.initialize["dap-virtual-text"] = function()
                require("nvim-dap-virtual-text")
            end
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = true,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
            "nvim-neotest/nvim-nio",
        },
        init = function()
            drawer.register({
                name = "dap",
                positions = { "left", "bottom" },
                open = function()
                    require("dapui").open()
                end,
                close = function()
                    require("dapui").close()
                end,
            })
        end,
        keys = {
            {
                drawer.with_prefix_key("d"),
                function()
                    drawer.open("dap")
                end,
                mode = "n",
                desc = "open dap",
            },
            {
                "<leader>dk",
                function()
                    require("dapui").eval()
                end,
                mode = "n",
                desc = "Debug eval",
            },
        },
        config = true,
    },
}
