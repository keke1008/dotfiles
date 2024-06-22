return {
    {
        "github/copilot.vim",
        cmd = "Copilot",
        event = "VeryLazy",
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            "github/copilot.vim",
            "nvim-lua/plenary.nvim",
        },
        keys = function()
            local function open_with_layout(layout)
                return function() require("CopilotChat").toggle({ layout = layout }) end
            end
            return {
                { "<leader>cr", function() require("CopilotChat").reset() end, desc = "reset chat" },
                { "<leader>c", "<CMD>CopilotChat<CR>", mode = { "x" }, desc = "open chat" },
                { "<leader>cv", open_with_layout("vertical"), desc = "CopilotChat open vertical" },
                { "<leader>ch", open_with_layout("horizontal"), desc = "CopilotChat open horizontal" },
                { "<leader>cf", open_with_layout("floating"), desc = "CopilotChat open floating" },
                { "<leader>co", open_with_layout("replace"), desc = "CopilotChat open replace" },
                {
                    "<leader>cc",
                    function() require("CopilotChat").toggle({ selection = require("CopilotChat.select").line }) end,
                    desc = "CopilotChat open line",
                },
            }
        end,
        cmd = "CopilotChat",
        opts = {
            selection = function(source)
                local select = require("CopilotChat.select")
                return select.visual(source) or select.buffer(source)
            end,
            window = {
                layout = "float",
                width = 0.7,
                height = 0.7,
            },
        },
    },
}
