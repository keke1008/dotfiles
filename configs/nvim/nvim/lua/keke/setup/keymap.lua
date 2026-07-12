local drawer = require("drawer")

vim.keymap.set("n", "<Esc>", "<CMD>write<CR>")
vim.keymap.set("n", "+", ",")
vim.keymap.set("i", "<C-e>", "<CR>")
vim.keymap.set("s", "<BS>", "<BS>i")
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>")

vim.keymap.set({ "n", "x" }, "j", function()
    return (vim.v.count == 0) and "gj" or "j"
end, { desc = "Down", expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
    return (vim.v.count == 0) and "gk" or "k"
end, { desc = "Up", expr = true })

drawer.setup({ prefix_key = "<leader>s" })
vim.keymap.set("n", drawer.with_prefix_key("hl"), function()
    drawer.close_by_position("left")
end, { desc = "close left drawer" })
vim.keymap.set("n", drawer.with_prefix_key("hr"), function()
    drawer.close_by_position("right")
end, { desc = "close right drawer" })
vim.keymap.set("n", drawer.with_prefix_key("hb"), function()
    drawer.close_by_position("bottom")
end, { desc = "close bottom drawer" })
vim.keymap.set("n", drawer.with_prefix_key("H"), function()
    drawer.close_all()
end, { desc = "close all drawers" })
