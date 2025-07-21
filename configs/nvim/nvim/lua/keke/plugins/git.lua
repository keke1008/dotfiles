return {
    {

        "lewis6991/gitsigns.nvim",
        event = "UIEnter",
        opts = {
            on_attach = function(bufnr)
                local opts = { buffer = bufnr }
                vim.keymap.set({ "n", "x", "o" }, "[g", "<CMD>Gitsigns prev_hunk<CR>", opts)
                vim.keymap.set({ "n", "x", "o" }, "]g", "<CMD>Gitsigns next_hunk<CR>", opts)
                vim.keymap.set("n", "<leader>gs", "<CMD>Gitsigns stage_hunk<CR>", opts)
                vim.keymap.set("n", "<leader>gr", "<CMD>Gitsigns reset_hunk<CR>", opts)
                vim.keymap.set("n", "<leader>gu", "<CMD>Gitsigns undo_stage_hunk<CR>", opts)
                vim.keymap.set("n", "<leader>gS", "<CMD>Gitsigns stage_buffer<CR>", opts)
                vim.keymap.set("n", "<leader>gR", "<CMD>Gitsigns reset_buffer<CR>", opts)
                vim.keymap.set("n", "<leader>gp", "<CMD>Gitsigns preview_hunk<CR>", opts)
                vim.keymap.set("n", "<leader>gd", "<CMD>Gitsigns diffthis<CR>", opts)
                vim.keymap.set("n", "<leader>gb", "<CMD>Gitsigns blame_line<CR>", opts)
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
