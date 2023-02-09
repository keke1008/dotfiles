local menu = require("keke.side_menu")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Esc>", "<CMD>write<CR>")
vim.keymap.set("n", "<leader><leader>", "<CMD>noh<CR>", { silent = true })
vim.keymap.set("s", "<BS>", "<BS>i")
vim.keymap.set("n", "+", ",")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

menu.remap_close("h")
menu.remap_ignore("i")
menu.remap_close_all("H")
