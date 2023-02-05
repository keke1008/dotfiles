local M = {}

function M.setup()
    local remap = vim.keymap.set

    remap("n", "<leader>fb", "<CMD>Telescope buffers<CR>")
    remap("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
    remap("n", "<leader>fg", "<CMD>Telescope git_files<CR>")
    remap("n", "<leader>fh", "<CMD>Telescope help_tags<CR>")
    remap("n", "<leader>fl", "<CMD>Telescope live_grep<CR>")
    remap("n", "<leader>fm", "<CMD>Telescope marks<CR>")
end

function M.config()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local themes = require("telescope.themes")

    telescope.setup({
        defaults = {
            mappings = {
                i = {
                    ["<C-b>"] = actions.preview_scrolling_up,
                    ["<C-f>"] = actions.preview_scrolling_down,
                },
            },
        },
        extensions = {
            ["ui-select"] = {
                themes.get_dropdown({}),
            },
        },
    })

    telescope.load_extension("ui-select")
end

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(...)
    vim.cmd([[PackerLoad telescope.nvim]])
    vim.ui.select(...)
end

return M
