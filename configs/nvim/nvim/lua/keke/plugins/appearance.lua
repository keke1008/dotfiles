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
        "folke/noice.nvim",
        lazy = false,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        keys = function()
            return {
                {
                    "<leader><leader>",
                    function()
                        require("notify").dismiss({})
                        vim.cmd("noh")
                    end,
                    mode = "n",
                    desc = "dimiss notifications and highlights"
                },
                {
                    "<C-f>",
                    function()
                        if not require("noice.lsp").scroll(4) then
                            return "<C-f>"
                        end
                    end,
                    silent = true,
                    expr = true,
                    mode = "n",
                    desc = "Scroll down noice lsp"
                },
                {
                    "<C-b>",
                    function()
                        if not require("noice.lsp").scroll(-4) then
                            return "<C-f>"
                        end
                    end,
                    silent = true,
                    expr = true,
                    mode = "n",
                    desc = "Scroll up noice lsp"
                },
            }
        end,
        opts = {
            commands = {
                history = {
                    view = "vsplit",
                },
            },
            views = {
                cmdline_popup = {
                    position = { row = "20%" },
                    zindex = 100,
                },
                confirm = {
                    position = { row = "20%" },
                },
                hover = {
                    border = { style = "rounded" },
                    position = { row = 2 },
                },
            },
            routes = {
                {
                    view = "mini",
                    filter = {
                        any = {
                            {
                                event = "msg_show",
                                any = {
                                    { kind = "emsg", find = "^E486" },
                                    { kind = "emsg", find = "^E37" },
                                    { kind = "wmsg", find = "^search hit " },
                                    { kind = "",     find = "written$" },
                                },
                            },
                            {
                                event = "notify",
                                kind = "info",
                                find = "^No code actions available", -- for lspsaga
                            },
                        },
                    },
                },
                {
                    opts = { skip = true },
                    filter = {
                        event = "notify",
                        kind = "warn",
                        find = "^warning: multiple different client offset_encodings", -- for clangd lsp
                    },
                }
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufRead", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
            "andymass/vim-matchup",
            "RRethy/nvim-treesitter-endwise",
            "windwp/nvim-ts-autotag",
        },
        main = "nvim-treesitter.configs",
        opts = {
            highlight = { enable = true },
            matchup = { enable = true },
            endwise = { enable = true },

            indent = {
                enable = true,
                disable = { "cpp", "python" },
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["ia"] = "@parameter.inner",
                        ["aa"] = "@parameter.outer",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["gsa"] = "@parameter.inner",
                        ["gsf"] = "@function.outer",
                        ["gsc"] = "@class.outer",
                    },
                    swap_previous = {
                        ["gSa"] = "@parameter.inner",
                        ["gSf"] = "@function.outer",
                        ["gSc"] = "@class.outer",
                    },
                },
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "v;",
                    node_incremental = ";",
                    scope_incremental = "g;",
                    node_decremental = "+",
                },
            },

            autotag = {
                enable = true,
            },
        }
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
