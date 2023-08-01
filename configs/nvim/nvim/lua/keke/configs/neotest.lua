local M = {}

function M.setup()
    local map = require("keke.utils.mapping")
    map.add_group("<leader>t", "neotest")

    local function with(f)
        return function() f(require("neotest").run) end
    end

    vim.keymap.set("n", "<leader>tt", with(function(run) run.run() end), { desc = "nearest test" })
    vim.keymap.set("n", "<leader>tf", with(function(run) run.run(vim.fn.expand("%")) end), { desc = "current file" })
    vim.keymap.set("n", "<leader>td", with(function(run) run.run({ strategy = "dap" }) end), { desc = "debug" })
    vim.keymap.set("n", "<leader>tl", with(function(run) run.run_last() end), { desc = "last" })
    vim.keymap.set("n", "<leader>ts", with(function(run) run.stop() end), { desc = "stop" })
    vim.keymap.set("n", "<leader>ta", with(function(run) run.attach() end), { desc = "attach" })
end

function M.config()
    local neotest = require("neotest")

    neotest.setup({
        adapters = {
            require("neotest-vitest"),
        },
    })
end

return M
