local gitsigns = require("gitsigns")
local remap = vim.keymap.set

gitsigns.setup({
    on_attach = function(bufnr)
        local opt = { buffer = bufnr }

        remap({ "n", "v" }, "<leader>h[", "<CMD>Gitsigns next_hunk<CR>", opt)
        remap({ "n", "v" }, "<leader>h]", "<CMD>Gitsigns next_hunk<CR>", opt)
        remap({ "n", "v" }, "<leader>hs", "<CMD>Gitsigns stage_hunk<CR>", opt)
        remap({ "n", "v" }, "<leader>hr", "<CMD>Gitsigns reset_hunk<CR>", opt)
        remap("n", "<leader>hS", "<CMD>Gitsigns stage_buffer<CR>", opt)
        remap("n", "<leader>hr", "<CMD>Gitsigns reset_buffer<CR>", opt)
        remap("n", "<leader>hu", "<CMD>Gitsigns undo_stage_hunk<CR>", opt)
        remap("n", "<leader>hp", "<CMD>Gitsigns preview_hunk<CR>", opt)
        remap("n", "<leader>hd", "<CMD>Gitsigns diffthis<CR>", opt)
        remap("n", "<leader>hb", "<CMD>Gitsigns blame_line<CR>", opt)
    end,
})
