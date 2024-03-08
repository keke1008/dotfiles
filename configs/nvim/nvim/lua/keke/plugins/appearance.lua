return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        lazy = false,
        init = function()
            vim.opt.list = true
            vim.opt.listchars:append("space:⋅")
            vim.opt.listchars:append("eol:↴")
        end,
        config = true,
    },
    {
        "folke/which-key.nvim",
        lazy = false,
        config = true,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        opts = function()
            local noice = require("noice")
            return {
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
                    lualine_c = {
                        "filename",
                        { noice.api.status.mode.get, cond = noice.api.status.mode.has, color = { fg = "#ff9e64" } },
                    },
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
            }
        end
    },
    {

        "lewis6991/gitsigns.nvim",
        event = "BufRead",
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
        }
    },
    {
        "folke/tokyonight.nvim",
        init = function()
            vim.cmd.colorscheme("tokyonight")
        end,
        opts = {
            style = "night",
            on_colors = function(colors)
                vim.api.nvim_set_hl(0, "WinSeparator", {
                    fg = colors.blue0,
                })
            end,
        }
    }
}
