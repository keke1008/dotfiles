return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "UIEnter",
        opts = {
            scope = {
                show_start = false,
                show_end = false,
            },
        },
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
            "folke/tokyonight.nvim",
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
        end,
    },
    {
        "romgrk/barbar.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        event = "UIEnter",
        keys = {
            { "[b", "<CMD>BufferPrev<CR>", mode = { "n", "x" } },
            { "]b", "<CMD>BufferNext<CR>", mode = { "n", "x" } },
            { "{B", "<CMD>BufferMovePrevious<CR>", mode = { "n", "x" } },
            { "}B", "<CMD>BufferMoveNext<CR>", mode = { "n", "x" } },
            { "<leader>bb", "<CMD>BufferClose<CR>", mode = { "n", "x" } },
            { "<leader>B", "<CMD>BufferClose<CR>", mode = { "n", "x" } },
            { "<leader>bD", "<CMD>BufferCloseBuffersRight<CR>", mode = { "n", "x" } },
            { "<leader>bU", "<CMD>BufferCloseBuffersLeft<CR>", mode = { "n", "x" } },
            { "<leader>bo", "<CMD>BufferCloseAllButVisible<CR>", mode = { "n", "x" } },
            { "<leader>bO", "<CMD>BufferCloseAllButCurrentOrPinned<CR>", mode = { "n", "x" } },
            { "<leader>bP", "<CMD>BufferCloseAllButPinned<CR>", mode = { "n", "x" } },
            { "<leader>bp", "<CMD>BufferPin<CR>", mode = { "n", "x" } },
            { "<leader>bf", "<CMD>BufferPick<CR>", mode = { "n", "x" } },
            { "<leader>b^", "<CMD>BufferFirst<CR>", mode = { "n", "x" } },
            { "<leader>b$", "<CMD>BufferLast<CR>", mode = { "n", "x" } },
            { "<leader>b1", "<CMD>BufferGoto 1<CR>", mode = { "n", "x" } },
            { "<leader>b2", "<CMD>BufferGoto 2<CR>", mode = { "n", "x" } },
            { "<leader>b3", "<CMD>BufferGoto 3<CR>", mode = { "n", "x" } },
            { "<leader>b4", "<CMD>BufferGoto 4<CR>", mode = { "n", "x" } },
            { "<leader>b5", "<CMD>BufferGoto 5<CR>", mode = { "n", "x" } },
            { "<leader>b6", "<CMD>BufferGoto 6<CR>", mode = { "n", "x" } },
            { "<leader>b7", "<CMD>BufferGoto 7<CR>", mode = { "n", "x" } },
            { "<leader>b8", "<CMD>BufferGoto 8<CR>", mode = { "n", "x" } },
            { "<leader>b9", "<CMD>BufferGoto 9<CR>", mode = { "n", "x" } },
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {
            animation = false,
        },
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
        "akinsho/git-conflict.nvim",
        version = "*",
        lazy = false,
        config = true,
    },
    {
        "folke/tokyonight.nvim",
        init = function() vim.cmd.colorscheme("tokyonight") end,
        opts = {
            style = "night",
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
            on_colors = function(colors)
                colors.border = colors.blue7
                colors.bg_statusline = colors.none
            end,
            on_highlights = function(highlights, colors)
                -- barbar.nvim
                highlights["BufferTabpageFill"].bg = colors.none
                highlights["BufferCurrentSign"].fg = colors.info
                highlights["BufferVisibleSign"].fg = colors.blue7
                highlights["BufferInactiveSign"].fg = colors.blue7

                -- indent-blankline.nvim
                highlights["IblScope"].fg = colors.blue0
            end,
        },
    },
}
