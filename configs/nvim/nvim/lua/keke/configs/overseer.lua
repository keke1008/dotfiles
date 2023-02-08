local M = {}

function M.setup()
    local remap = vim.keymap.set
    local keymap = require("keke.keymap")
    local l2 = keymap.l2
    local side_menu = require("keke.side_menu")

    keymap.register_group(l2("ov"), "Overseer")

    remap("n", l2("ovr"), "<CMD>OverseerRun<CR>")
    remap("n", l2("ovl"), function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
            vim.notify("No task found", vim.log.levels.WARN)
        else
            overseer.run_action(tasks[1], "restart")
        end
    end, { desc = "restart last task" })

    side_menu.register("Overseer", "o", {
        position = "right",
        open = function() vim.cmd([[OverseerOpen right]]) end,
        close = function() vim.cmd([[OverseerClose]]) end,
    })
end

function M.config()
    local overseer = require("overseer")

    overseer.setup({
        templates = { "builtin", "keke" },
    })
end

return M
