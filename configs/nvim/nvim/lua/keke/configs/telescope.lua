local M = {}

function M.setup()
    local remap = vim.keymap.set

    remap("n", "<C-t>", "<CMD>Telescope<CR>")
    remap("n", "<leader>fb", "<CMD>Telescope builtin<CR>")
    remap("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
    remap("n", "<leader>fg", "<CMD>Telescope git_files<CR>")
    remap("n", "<leader>fl", "<CMD>Telescope live_grep<CR>")
end

function M.config()
    local telescope = require("telescope")
    telescope.setup({})
end

return M
