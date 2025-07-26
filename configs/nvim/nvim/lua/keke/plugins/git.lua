local keymap = require("keke.keymap")
local git_buffers = keymap.lib.BufferSet.new()
keymap.helper.git_buffers = git_buffers

return {
    {

        "lewis6991/gitsigns.nvim",
        event = "UIEnter",
        cmd = "Gitsigns",
        opts = {
            on_attach = function(bufnr)
                git_buffers:add(bufnr)
            end,
        },
    },
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        lazy = false,
        keys = {
            { "<leader>gcf", "<CMD>GitConflictListQf" },
            { "<leader>gco", "<Plug>(git-conflict-ours)" },
            { "<leader>gct", "<Plug>(git-conflict-theirs)" },
            { "<leader>gcb", "<Plug>(git-conflict-both)" },
            { "<leader>gcn", "<Plug>(git-conflict-none)" },
            { "{G", "<Plug>(git-conflict-prev-conflict)" },
            { "}G", "<Plug>(git-conflict-next-conflict)" },
        },
        opts = { default_mappings = false },
    },
    {
        "ruifm/gitlinker.nvim",
        keys = { "<leader>gy", mode = { "n", "x" } },
        config = true,
    },
}
