return {
    {
        "github/copilot.vim",
        cmd = "Copilot",
        event = "VeryLazy",
    },
    {
        "jackMort/ChatGPT.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
            "nvim-telescope/telescope.nvim"
        },
        keys = function()
            local mode = { "n", "v" }
            return {
                { "<leader>cc", "ChatGPTCompleteCode",                  mode = mode, desc = "CompleteCode" },
                { "<leader>ce", "ChatGPTEditWithInstruction",           mode = mode, desc = "Edit with instruction" },
                { "<leader>cg", "ChatGPTRun grammar_correction",        mode = mode, desc = "Grammar Correction" },
                { "<leader>ct", "ChatGPTRun translate",                 mode = mode, desc = "Translate" },
                { "<leader>ck", "ChatGPTRun keywords",                  mode = mode, desc = "Keywords" },
                { "<leader>cd", "ChatGPTRun docstring",                 mode = mode, desc = "Docstring" },
                { "<leader>ca", "ChatGPTRun add_tests",                 mode = mode, desc = "Add Tests" },
                { "<leader>co", "ChatGPTRun optimize_code",             mode = mode, desc = "Optimize Code" },
                { "<leader>cs", "ChatGPTRun summarize",                 mode = mode, desc = "Summarize" },
                { "<leader>cf", "ChatGPTRun fix_bugs",                  mode = mode, desc = "Fix Bugs" },
                { "<leader>cx", "ChatGPTRun explain_code",              mode = mode, desc = "Explain Code" },
                { "<leader>cr", "ChatGPTRun roxygen_edit",              mode = mode, desc = "Roxygen Edit" },
                { "<leader>cl", "ChatGPTRun code_readability_analysis", mode = mode, desc = "Code Readability Analysis" },
            }
        end,
        config = true,
    }
}
