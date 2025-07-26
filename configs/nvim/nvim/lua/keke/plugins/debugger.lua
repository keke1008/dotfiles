local drawer = require("drawer")
local keymap = require("keke.keymap")
local dap_stopping = keymap.lib.StatefulCondition.new(false)
keymap.helper.dap_stopping = dap_stopping

vim.fn.sign_define({
    { name = "DapStopped", text = " ", texthl = "DebugStopSign", linehl = "DebugStopLine" },
    { name = "DapBreakpoint", text = " ", texthl = "DebugBreakpointSign" },
    { name = "DapBreakpointRejected", text = " ", texthl = "DebugBreakpointSign" },
    { name = "DapBreakpointCondition", text = " ", texthl = "DebugBreakpointSign" },
    { name = "DapLogPoint", text = " ", texthl = "DebugBreakpointSign" },
})

return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            -- `mason.nvim` must be configured before `mason-nvim-dap.nvim`
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            handlers = {},
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "mxsdev/nvim-dap-vscode-js", opts = { adapters = { "pwa-node" } } },
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            local dap = require("dap")
            dap.listeners.after.event_stopped["keymap"] = function()
                dap_stopping:update(true)
            end
            dap.listeners.after.event_continued["keymap"] = function()
                dap_stopping:update(false)
            end

            dap.listeners.after.event_initialized["dap-hook"] = function()
                drawer.push("dap")
            end
            dap.listeners.before.event_terminated["dap-hook"] = function()
                drawer.close_by_name("dap")
            end
            dap.listeners.before.event_exited["dap-hook"] = function()
                drawer.close_by_name("dap")
            end

            -- load virtual-text plugin
            dap.listeners.before.initialize["dap-virtual-text"] = function()
                require("nvim-dap-virtual-text")
            end

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
                program = prompt_executable,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            })
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
        },
        config = true,
    },
}
