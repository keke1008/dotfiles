local remap = vim.keymap.set
local l2 = require("keke.keymap").l2

remap({ "n", "v" }, l2("t"), "<CMD>Translate<CR>")
vim.g.translator_target_lang = "ja"
