local gitsigns = require("gitsigns")
local map = require("keke.utils.mapping")

gitsigns.setup({
    on_attach = function(bufnr)
        map.add_group("<leader>h", "Gitsigns")

        local opts = { buffer = bufnr }
        vim.keymap.set({ "n", "x" }, "[h", "<CMD>Gitsigns next_hunk<CR>", opts)
        vim.keymap.set({ "n", "x" }, "]h", "<CMD>Gitsigns next_hunk<CR>", opts)
        vim.keymap.set({ "n", "x" }, "<leader>hs", "<CMD>Gitsigns stage_hunk<CR>", opts)
        vim.keymap.set({ "n", "x" }, "<leader>hr", "<CMD>Gitsigns reset_hunk<CR>", opts)
        vim.keymap.set("n", "<leader>hS", "<CMD>Gitsigns stage_buffer<CR>", opts)
        vim.keymap.set("n", "<leader>hr", "<CMD>Gitsigns reset_buffer<CR>", opts)
        vim.keymap.set("n", "<leader>hu", "<CMD>Gitsigns undo_stage_hunk<CR>", opts)
        vim.keymap.set("n", "<leader>hp", "<CMD>Gitsigns preview_hunk<CR>", opts)
        vim.keymap.set("n", "<leader>hd", "<CMD>Gitsigns diffthis<CR>", opts)
        vim.keymap.set("n", "<leader>hb", "<CMD>Gitsigns blame_line<CR>", opts)
    end,
})
