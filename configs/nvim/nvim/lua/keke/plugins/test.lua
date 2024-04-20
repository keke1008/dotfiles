return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "marilari88/neotest-vitest",
            "marilari88/neotest-jest",
            "nvim-neotest/neotest-python",
            "rouge8/neotest-rust",
            "nvim-neotest/neotest-go"
        },
        cmd = "Neotest",
        keys = function()
            local function with(f)
                return function() f(require("neotest").run) end
            end

            return {
                { "<leader>tt", with(function(run) run.run() end),                     mode = "n", desc = "nearest test" },
                { "<leader>tf", with(function(run) run.run(vim.fn.expand("%")) end),   mode = "n", desc = "current file" },
                { "<leader>td", with(function(run) run.run({ strategy = "dap" }) end), mode = "n", desc = "debug" },
                { "<leader>tl", with(function(run) run.run_last() end),                mode = "n", desc = "last" },
                { "<leader>ts", with(function(run) run.stop() end),                    mode = "n", desc = "stop" },
                { "<leader>ta", with(function(run) run.attach() end),                  mode = "n", desc = "attach" },
            }
        end,
        opts = function()
            return {
                adapters = {
                    require("neotest-vitest"),
                    require("neotest-jest"),
                    require("neotest-python"),
                    require("neotest-rust"),
                    require("neotest-go")
                },
            }
        end

    }
}
