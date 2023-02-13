local map = require("keke.utils.mapping")

vim.keymap.set({ "n", "v" }, map.l2("tr"), "<CMD>Translate<CR>")
vim.g.translator_target_lang = "ja"
