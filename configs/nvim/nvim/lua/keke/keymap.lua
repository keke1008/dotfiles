local sidemenu = require("keke.sidemenu")

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

sidemenu.close_keymap("h")
