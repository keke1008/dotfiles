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

            vim.cmd("highlight lualine_c_inactive guibg=NONE")
            vim.cmd("highlight lualine_c_normal guibg=NONE")
        end,
    },
    {
        "romgrk/barbar.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            { "lewis6991/gitsigns.nvim", optional = true },
        },
        event = "UIEnter",
        keys = {
            { "[b",         "<CMD>BufferPrev<CR>" },
            { "]b",         "<CMD>BufferNext<CR>" },
            { "{B",         "<CMD>BufferMovePrevious<CR>" },
            { "}B",         "<CMD>BufferMoveNext<CR>" },
            { "<leader>bd", "<CMD>BufferClose<CR>" },
            { "<leader>bD", "<CMD>BufferCloseBuffersRight<CR>" },
            { "<leader>bU", "<CMD>BufferCloseBuffersLeft<CR>" },
            { "<leader>bo", "<CMD>BufferCloseAllButCurrentOrPinned<CR>" },
            { "<leader>bO", "<CMD>BufferCloseAllButCurrent<CR>" },
            { "<leader>bP", "<CMD>BufferCloseAllButPinned<CR>" },
            { "<leader>bp", "<CMD>BufferPin<CR>" },
            { "<leader>bs", "<CMD>BufferPick<CR>" },
            { "<leader>b^", "<CMD>BufferFirst<CR>" },
            { "<leader>b$", "<CMD>BufferLast<CR>" },
            { "<leader>b1", "<CMD>BufferGoto 1<CR>" },
            { "<leader>b2", "<CMD>BufferGoto 2<CR>" },
            { "<leader>b3", "<CMD>BufferGoto 3<CR>" },
            { "<leader>b4", "<CMD>BufferGoto 4<CR>" },
            { "<leader>b5", "<CMD>BufferGoto 5<CR>" },
            { "<leader>b6", "<CMD>BufferGoto 6<CR>" },
            { "<leader>b7", "<CMD>BufferGoto 7<CR>" },
            { "<leader>b8", "<CMD>BufferGoto 8<CR>" },
            { "<leader>b9", "<CMD>BufferGoto 9<CR>" },
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
        "folke/tokyonight.nvim",
        init = function() vim.cmd.colorscheme("tokyonight") end,
        opts = {
            style = "night",
            transparent = true,
            styles = {
                sidebar = "transparent",
                floats = "transparent",
            },
            on_colors = function(colors) vim.cmd.highlight("WinSeparator", "guifg=" .. colors.blue0) end,
        },
    },
}
