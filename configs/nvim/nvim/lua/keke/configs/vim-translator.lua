local remap = vim.keymap.set

remap({ "n", "v" }, "<one-shot-leader>t", "<CMD>Translate<CR>")
vim.g.translator_target_lang = "ja"
