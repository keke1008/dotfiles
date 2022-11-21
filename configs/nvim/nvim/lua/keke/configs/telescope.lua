local telescope = require("telescope")

local remap = vim.keymap.set

telescope.setup({})

remap("n", "<leader>fb", "<CMD>Telescope builtin<CR>")
remap("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
remap("n", "<leader>fg", "<CMD>Telescope git_files<CR>")
remap("n", "<leader>fl", "<CMD>Telescope live_grep<CR>")
