return {
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
}
