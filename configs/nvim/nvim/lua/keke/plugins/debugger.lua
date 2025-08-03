local drawer = require("drawer")

vim.fn.sign_define({
    { name = "DapStopped", text = " ", texthl = "DebugStopSign", linehl = "DebugStopLine" },
    { name = "DapBreakpoint", text = " ", texthl = "DebugBreakpointSign" },
    { name = "DapBreakpointRejected", text = " ", texthl = "DebugBreakpointSign" },
    { name = "DapBreakpointCondition", text = " ", texthl = "DebugBreakpointSign" },
    { name = "DapLogPoint", text = " ", texthl = "DebugBreakpointSign" },
})

local function set_conditional_braekpoint()
    vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then
            require("dap").set_breakpoint(condition)
        end
    end)
end

local function run_last_debug_session()
    require("dap").run_last()
end

return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            -- `mason.nvim` must be configured before `mason-nvim-dap.nvim`
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
        keys = {
            { "<leader>db", "<CMD>DapToggleBreakpoint<CR>", mode = "n" },
            { "<leader>dv", set_conditional_braekpoint, mode = "n", desc = "Set condition breakpoint" },
            { "<leader>dc", "<CMD>DapContinue<CR>", mode = "n" },
            { "<leader>di", "<CMD>DapStepInto<CR>", mode = "n" },
            { "<leader>do", "<CMD>DapStepOver<CR>", mode = "n" },
            { "<leader>dp", "<CMD>DapStepOut<CR>", mode = "n" },
            { "<leader>dl", run_last_debug_session, mode = "n", desc = "Run last debug session" },
            { "<leader>dq", "<CMD>DapDisconnect<CR>", mode = "n" },
        },
        config = function()
            local dap = require("dap")
            local Hydra = require("hydra")

            dap.adapters.rdbg = function(callback, config)
                if config.request ~= "launch" then
                    vim.notify(
                        "adapter `rdbg` only supports 'launch' type",
                        vim.log.levels.ERROR,
                        { title = "nvim-dap" }
                    )
                    return
                end

                local port = vim.env.RUBY_DEBUG_PORT or tostring(math.random(49152, 65535))

                callback({
                    type = "server",
                    port = port,
                    executable = {
                        command = "rdbg",
                        args = {
                            "--open",
                            "--port",
                            port,
                            "--stop-at-load",
                            "--command",
                            "--",
                            config.command,
                            unpack(config.args),
                        },
                    },
                    localfs = true,
                })
            end

            -- Tips:
            -- Rails does not require `debug` gem, so we need to require it manually
            -- to use `rdbg` adapter with Rails applications.
            -- Like `RUBYOPT="-r debug/open" RUBY_DEBUG_OPEN=true RUBY_DEBUG_PORT=12345 bundle exec rails s`.
            -- https://github.com/rails/rails/pull/51692
            dap.adapters.rdbg_remote = function(callback, config)
                if config.request ~= "attach" then
                    vim.notify(
                        "adapter `rdbg_remote` only supports 'attach' type",
                        vim.log.levels.ERROR,
                        { title = "nvim-dap" }
                    )
                    return
                end

                callback({
                    type = "server",
                    port = tonumber(vim.env.RUBY_DEBUG_PORT) or 12345,
                    localfs = true,
                })
            end

            local function append_configuration(langs, config)
                langs = type(langs) == "table" and langs or { langs }
                for _, lang in ipairs(langs) do
                    dap.configurations[lang] = dap.configurations[lang] or {}
                    table.insert(dap.configurations[lang], config)
                end
            end

            append_configuration({ "c", "cpp", "rust" }, {
                name = "Launch executable file with codelldb",
                type = "codelldb",
                request = "launch",
                program = "${command:pickFile}",
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            })
            append_configuration("typescript", {
                name = "tsx",
                type = "pwa-node",
                request = "launch",
                program = "${command:pickFile}",
                cwd = "${workspaceFolder}",
                runtimeExecutable = "${workspaceFolder}/node_modules/.bin/tsx",
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal",
                skipFiles = { "<node_internals>/**" },
            })
            append_configuration("ruby", {
                name = "[nvim] Attach rdbg",
                type = "rdbg_remote",
                request = "attach",
                localfs = true,
            })
            append_configuration("ruby", {
                name = "[nvim] Debug Current Ruby File",
                type = "rdbg",
                request = "launch",
                command = "ruby",
                args = { "${file}" },
                cwd = "${workspaceFolder}",
            })
            append_configuration("ruby", {
                name = "[nvim] Debug rspec under the cursor",
                type = "rdbg",
                request = "launch",
                command = "rspec",
                args = function()
                    return { "${file}:" .. vim.fn.line(".") }
                end,
                cwd = "${workspaceFolder}",
            })

            local keymap = Hydra({
                name = "Debugger",
                mode = "n",
                hint = "Debug",
                config = { color = "pink" },
                heads = {
                    { "c", "<CMD>DapContinue<CR>" },
                    { "i", "<CMD>DapStepInto<CR>" },
                    { "o", "<CMD>DapStepOver<CR>" },
                    { "p", "<CMD>DapStepOut<CR>" },
                },
            })

            local function close()
                drawer.close_by_name("dap")
                keymap:exit()
            end
            dap.listeners.after.event_initialized["dap-hook"] = function()
                drawer.push("dap")
            end
            dap.listeners.after.event_stopped["keymap"] = function()
                keymap:activate()
            end
            dap.listeners.before.event_continued["keymap"] = function()
                keymap:exit()
            end
            dap.listeners.before.event_terminated["dap-hook"] = close
            dap.listeners.before.event_exited["dap-hook"] = close
            dap.listeners.before.terminate["dap-hook"] = close
            dap.listeners.before.disconnect["dap-hook"] = close

            -- load virtual-text plugin
            dap.listeners.before.initialize["dap-virtual-text"] = function()
                require("nvim-dap-virtual-text")
            end
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
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
