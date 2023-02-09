local map = require("keke.utils.mapping")

local M = {}

function M.setup()
    map.add_group("<leader>f", "Telescope")

    vim.keymap.set("n", "<leader>fb", "<CMD>Telescope buffers<CR>")
    vim.keymap.set("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
    vim.keymap.set("n", "<leader>fg", "<CMD>Telescope git_files<CR>")
    vim.keymap.set("n", "<leader>fh", "<CMD>Telescope help_tags<CR>")
    vim.keymap.set("n", "<leader>fl", "<CMD>Telescope live_grep<CR>")
    vim.keymap.set("n", "<leader>fm", "<CMD>Telescope marks<CR>")
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
