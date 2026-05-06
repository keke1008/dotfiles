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
            "nvim-neotest/neotest-go",
            { "leoluz/nvim-dap-go", dependencies = { "mfussenegger/nvim-dap" }, config = true },
            "olimorris/neotest-rspec",
            { "suketa/nvim-dap-ruby", dependencies = { "mfussenegger/nvim-dap" }, config = true },
        },
        cmd = "Neotest",
        keys = function()
            local function with(f)
                return function()
                    f(require("neotest").run)
                end
            end

            local function debug_go(method)
                if vim.bo.filetype ~= "go" then
                    return false
                end

                if vim.fn.executable("dlv") == 1 then
                    require("dap-go")[method]()
                else
                    vim.notify("delve not found", vim.log.levels.INFO)
                end
                return true
            end

            return {
                {
                    "<leader>tt",
                    with(function(run)
                        run.run()
                    end),
                    mode = "n",
                    desc = "nearest test",
                },
                {
                    "<leader>tf",
                    with(function(run)
                        run.run(vim.fn.expand("%"))
                    end),
                    mode = "n",
                    desc = "current file",
                },
                {
                    "<leader>td",
                    with(function(run)
                        if not debug_go("debug_test") then
                            run.run({ strategy = "dap" })
                        end
                    end),
                    mode = "n",
                    desc = "debug",
                },
                {
                    "<leader>tl",
                    with(function(run)
                        if not debug_go("debug_last_test") then
                            run.run_last()
                        end
                    end),
                    mode = "n",
                    desc = "last",
                },
                {
                    "<leader>ts",
                    with(function(run)
                        run.stop()
                    end),
                    mode = "n",
                    desc = "stop",
                },
                {
                    "<leader>ta",
                    with(function(run)
                        run.attach()
                    end),
                    mode = "n",
                    desc = "attach",
                },
            }
        end,
        opts = function()
            return {
                adapters = {
                    require("neotest-vitest"),
                    require("neotest-jest"),
                    require("neotest-python"),
                    require("neotest-rust"),
                    require("neotest-go"),
                    require("neotest-rspec"),
                },
            }
        end,
    },
}
