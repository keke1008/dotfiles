return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        init = function()
            -- vim.opt.list = true
            -- vim.opt.listchars:append("space:⋅")
            -- vim.opt.listchars:append("eol:↴")
        end,
        event = "UIEnter",
        config = true,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = true,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            { "folke/noice.nvim", optional = true },
        },
        event = "UIEnter",
        config = function()
            local has_noice, noice = pcall(require, "noice")
            local noice_status = nil
            if has_noice then
                noice_status = {
                    noice.api.status.mode.get,
                    cond = noice.api.status.mode.has,
                    color = { fg = "#ff9e64" },
                }
            end

            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "tokyonight",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {},
                    always_divide_middle = true,
                    global_status = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename", noice_status },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                extensions = {},
            })

            vim.cmd("highlight lualine_c_inactive guibg=NONE")
            vim.cmd("highlight lualine_c_normal guibg=NONE")
        end,
    },
    {

        "lewis6991/gitsigns.nvim",
        event = "UIEnter",
        opts = {
            on_attach = function(bufnr)
                local opts = { buffer = bufnr }
                vim.keymap.set({ "n", "x" }, "[h", "<CMD>Gitsigns prev_hunk<CR>", opts)
                vim.keymap.set({ "n", "x" }, "]h", "<CMD>Gitsigns next_hunk<CR>", opts)
                vim.keymap.set({ "n", "x" }, "<leader>hs", "<CMD>Gitsigns stage_hunk<CR>", opts)
                vim.keymap.set({ "n", "x" }, "<leader>hr", "<CMD>Gitsigns reset_hunk<CR>", opts)
                vim.keymap.set("n", "<leader>hS", "<CMD>Gitsigns stage_buffer<CR>", opts)
                vim.keymap.set("n", "<leader>hr", "<CMD>Gitsigns reset_buffer<CR>", opts)
                vim.keymap.set("n", "<leader>hu", "<CMD>Gitsigns undo_stage_hunk<CR>", opts)
                vim.keymap.set("n", "<leader>hp", "<CMD>Gitsigns preview_hunk<CR>", opts)
                vim.keymap.set("n", "<leader>hd", "<CMD>Gitsigns diffthis<CR>", opts)
                vim.keymap.set("n", "<leader>hb", "<CMD>Gitsigns blame_line<CR>", opts)
            end,
        },
    },
    {
        "folke/tokyonight.nvim",
        init = function() vim.cmd.colorscheme("tokyonight") end,
        opts = {
            style = "night",
            transparent = true,
            on_colors = function(colors)
                vim.cmd.highlight("WinSeparator", "guifg=" .. colors.blue0)
                vim.cmd.highlight("FloatBorder", "guibg=NONE")
            end,
        },
    },
}
