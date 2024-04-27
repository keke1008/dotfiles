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
            "nvim-telescope/telescope.nvim",
        },
        event = "VeryLazy",
        opts = function()
            return {
                api_key_cmd = "pass show personal/openai.com/apikey",
            }
        end,
    },
}
