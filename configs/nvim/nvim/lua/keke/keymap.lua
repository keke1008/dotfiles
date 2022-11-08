local menu = require("keke.side_menu")

local remap = vim.keymap.set

remap({ "n", "x" }, "ga", "<Plug>(EasyAlign)")
remap("n", "gj", "<Plug>(jumpcursor-jump)")
remap("n", "j", "gj")
remap("n", "k", "gk")
remap("n", "<Esc>", "<CMD>write<CR>")
remap("n", "<leader><leader>", "<CMD>noh<CR>", { silent = true })
remap("s", "<BS>", "<BS>i")
remap("n", "<C-t>", "<CMD>Telescope<CR>")

remap("t", "<Esc>", "<C-\\><C-n>")

menu.remap_close("h")
menu.remap_ignore("i")
menu.remap_close_all("H")
