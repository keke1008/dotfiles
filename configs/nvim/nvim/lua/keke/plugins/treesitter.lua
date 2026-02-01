local function txtobj(submodule, method)
    return function(query)
        return function()
            return require("nvim-treesitter-textobjects." .. submodule)[method](query)
        end
    end
end

local txtobj_swap_next = txtobj("swap", "swap_next")
local txtobj_swap_previous = txtobj("swap", "swap_previous")
local txtobj_select = txtobj("select", "select_textobject")
local txtobj_goto_next = txtobj("move", "goto_next_start")
local txtobj_goto_previous = txtobj("move", "goto_previous_start")

return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 1 } },
            "RRethy/nvim-treesitter-endwise",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("keke_treesitter_start", {}),
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            opts = {
                enable_close_on_slash = true,
            },
        },
    },
    {
        "andymass/vim-matchup",
        lazy = false,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        keys = {
            { "gsa", txtobj_swap_next("@parameter.inner"), desc = "Swap next parameter" },
            { "gSa", txtobj_swap_previous("@parameter.inner"), desc = "Swap previous parameter" },
            { "af", txtobj_select("@function.outer"), mode = { "o", "x" }, desc = "Around function" },
            { "if", txtobj_select("@function.inner"), mode = { "o", "x" }, desc = "Inner function" },
            { "as", txtobj_select("@class.outer"), mode = { "o", "x" }, desc = "Around class" },
            { "ic", txtobj_select("@class.inner"), mode = { "o", "x" }, desc = "Inner class" },
            { "]f", txtobj_goto_next("@function.outer"), desc = "Next function start" },
            { "[f", txtobj_goto_previous("@function.outer"), desc = "Previous function start" },
            { "]c", txtobj_goto_next("@class.outer"), desc = "Next class start" },
            { "[c", txtobj_goto_previous("@class.outer"), desc = "Previous class start" },
        },
        opts = {
            select = { lookahead = true },
            move = { set_jumps = true },
        },
    },
    {
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        keys = { { "gj", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
        opts = {
            use_default_keymaps = false,
            max_join_length = 1000,
        },
    },
}
