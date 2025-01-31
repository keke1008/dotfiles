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
                    -- color = { fg = "#ff9e64" },
                }
            end

            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "blue",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {},
                    -- always_divide_middle = true,
                    global_status = true,
                },
                sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        "mode",
                        { "diff", separator = { left = "", right = "" } },
                        "branch",
                        { "diagnostics", separator = { left = "", right = "" } },
                        "filename",
                        noice_status,
                    },
                    lualine_x = { "encoding", "fileformat", "filetype", "location" },
                    lualine_y = {},
                    lualine_z = {},
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
        keys = function()
            local function multi_win_exists()
                return #vim.api.nvim_list_wins() > 1
            end

            local function with_quit(cmd)
                return function()
                    vim.cmd(cmd)
                    if multi_win_exists() then
                        vim.cmd.quit()
                    end
                end
            end

            local function with_only(cmd)
                return function()
                    vim.cmd(cmd)
                    if multi_win_exists() then
                        vim.cmd.only()
                    end
                end
            end

            local mode = { "n", "x" }

            return {
                { "[b", "<CMD>BufferPrev<CR>", mode = mode },
                { "]b", "<CMD>BufferNext<CR>", mode = mode },
                { "{B", "<CMD>BufferMovePrevious<CR>", mode = mode },
                { "}B", "<CMD>BufferMoveNext<CR>", mode = mode },
                { "<leader>bb", "<CMD>BufferClose<CR>", mode = mode },
                { "<leader>B", with_quit("BufferClose"), mode = mode },
                { "<leader>bD", "<CMD>BufferCloseBuffersRight<CR>", mode = mode },
                { "<leader>bU", "<CMD>BufferCloseBuffersLeft<CR>", mode = mode },
                { "<leader>bo", "<CMD>BufferCloseAllButVisible<CR>", mode = mode },
                { "<leader>bo", with_only("BufferCloseAllButVisible"), mode = mode },
                { "<leader>bO", "<CMD>BufferCloseAllButCurrentOrPinned<CR>", mode = mode },
                { "<leader>bO", with_only("BufferCloseAllButCurrentOrPinned"), mode = mode },
                { "<leader>bP", "<CMD>BufferCloseAllButPinned<CR>", mode = mode },
                { "<leader>bp", "<CMD>BufferPin<CR>", mode = mode },
                { "<leader>bf", "<CMD>BufferPick<CR>", mode = mode },
                { "<leader>b^", "<CMD>BufferFirst<CR>", mode = mode },
                { "<leader>b$", "<CMD>BufferLast<CR>", mode = mode },
            }
        end,
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        opts = {
            animation = false,
        },
    },
    {
        "folke/tokyonight.nvim",
        init = function()
            vim.cmd.colorscheme("tokyonight")
        end,
        config = function()
            require("tokyonight").setup({
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
                    highlights["LineNr"].fg = colors.dark3
                    highlights["LineNrAbove"].fg = colors.dark3
                    highlights["LineNrBelow"].fg = colors.dark3

                    -- nvim-dap
                    highlights["DebugStopLine"] = { bg = colors.blue0 }
                    highlights["DebugStopSign"] = { fg = colors.blue }
                    highlights["DebugBreakpointSign"] = { fg = colors.red }

                    -- barbar.nvim
                    highlights["BufferTabpageFill"].bg = colors.none
                    highlights["BufferCurrentSign"].fg = colors.info
                    highlights["BufferVisibleSign"].fg = colors.blue7
                    highlights["BufferInactiveSign"].fg = colors.blue7

                    -- indent-blankline.nvim
                    highlights["IblScope"].fg = colors.blue0

                    -- below guicursor option
                    highlights["KekeCursorNormal"] = {
                        fg = colors.bg,
                        bg = colors.blue,
                    }
                    highlights["KekeCursorInsert"] = {
                        fg = colors.bg,
                        bg = colors.blue,
                    }
                    highlights["KekeCursorVisual"] = {
                        fg = colors.bg,
                        bg = colors.purple,
                    }
                    highlights["KekeCursorReplace"] = {
                        fg = colors.bg,
                        bg = colors.red,
                    }
                end,
            })

            local guicursor = {
                "n-c:block-KekeCursorNormal",
                "i-ci-ve:ver25-KekeCursorInsert",
                "v:block-KekeCursorVisual",
                "r-cr-o:hor20-KekeCursorReplace",
            }
            vim.o.guicursor = table.concat(guicursor, ",")
        end,
    },
    {
        "pocco81/true-zen.nvim",
        keys = {
            { "\\tza", "<CMD>TZAtaraxis<CR>" },
            { "\\tzf", "<CMD>TZFocus<CR>" },
            { "\\tzr", "<CMD>TZMinimalist<CR>" },
        },
        opts = {
            integrations = {
                lualine = true,
            },
        },
    },
    {
        "sindrets/winshift.nvim",
        commands = { "WinShift" },
        keys = { { "<C-w>" } },
        config = function()
            local winshift = require("winshift")
            winshift.setup({
                keymaps = { disable_defaults = true },
            })

            local Hydra = require("hydra")
            Hydra({
                name = "window",
                mode = "n",
                body = "<C-w><C-w>",
                hint = "Window",
                heads = {
                    { "+", "10<C-w>+" },
                    { "-", "10<C-w>-" },
                    { ">", "10<C-w>>" },
                    { "<", "10<C-w><" },
                    { "h", "<C-w>h" },
                    { "j", "<C-w>j" },
                    { "k", "<C-w>k" },
                    { "l", "<C-w>l" },
                    { "H", "<CMD>WinShift left<CR>" },
                    { "J", "<CMD>WinShift down<CR>" },
                    { "K", "<CMD>WinShift up<CR>" },
                    { "L", "<CMD>WinShift right<CR>" },
                    { "<C-H>", "<CMD>WinShift far_left<CR>" },
                    { "<C-J>", "<CMD>WinShift far_down<CR>" },
                    { "<C-K>", "<CMD>WinShift far_up<CR>" },
                    { "<C-L>", "<CMD>WinShift far_right<CR>" },
                },
            })
        end,
    },
}
