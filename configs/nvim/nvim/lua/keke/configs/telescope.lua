local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")

local remap = vim.keymap.set

telescope.setup({})

remap("n", "<leader>fb", telescope_builtin.builtin)
remap("n", "<leader>ff", telescope_builtin.find_files)
remap("n", "<leader>fg", telescope_builtin.git_files)
remap("n", "<leader>fl", telescope_builtin.live_grep)
