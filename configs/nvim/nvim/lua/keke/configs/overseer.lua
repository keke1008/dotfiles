local map = require("keke.utils.mapping")

local M = {}

function M.setup()
    local side_menu = require("keke.side_menu")

    map.add_group(map.l2("ov"), "Overseer")

    vim.keymap.set("n", map.l2("ovr"), "<CMD>OverseerRun<CR>")
    vim.keymap.set("n", map.l2("ovl"), function()
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
