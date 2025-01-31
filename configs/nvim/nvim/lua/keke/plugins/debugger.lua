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

local DEBUG_KEYMAP = {
    { "b", "<CMD>DapToggleBreakpoint<CR>", mode = "n" },
    { "v", set_conditional_braekpoint, mode = "n", desc = "Set condition breakpoint" },
    { "c", "<CMD>DapContinue<CR>", mode = "n" },
    { "i", "<CMD>DapStepInto<CR>", mode = "n" },
    { "o", "<CMD>DapStepOver<CR>", mode = "n" },
    { "p", "<CMD>DapStepOut<CR>", mode = "n" },
    { "q", "<CMD>DapTerminate<CR>", mode = "n" },
    { "l", run_last_debug_session, mode = "n", desc = "Run last debug session" },
}

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
        keys = vim.iter(DEBUG_KEYMAP)
            :map(function(e)
                local lhs = "<leader>d" .. e[1]
                return vim.tbl_extend("force", e, { lhs })
            end)
            :totable(),
        config = function()
            local dap = require("dap")
            local Hydra = require("hydra")

            local keymap = Hydra({
                name = "Debugger",
                mode = "n",
                body = "<leader>d",
                heads = DEBUG_KEYMAP,
                hint = "Debug",
                config = {
                    color = "pink",
                },
            })

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

            dap.listeners.after.event_initialized["dap-hook"] = function()
                drawer.push("dap")
                keymap:activate()
            end
            dap.listeners.before.event_terminated["dap-hook"] = function()
                drawer.close_by_name("dap")
                keymap:exit()
            end
            dap.listeners.before.event_exited["dap-hook"] = function()
                drawer.close_by_name("dap")
                keymap:exit()
            end

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
