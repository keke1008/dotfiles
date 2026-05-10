return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "none",
            ["<C-p>"] = { "show_and_insert", "select_prev", "fallback" },
            ["<C-n>"] = { "show_and_insert", "select_next", "fallback" },
            ["<Enter>"] = { "accept", "fallback" },
            ["<C-j>"] = { "snippet_forward", "fallback" },
            ["<C-k>"] = { "snippet_backward", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },

        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 300,
            },
        },

        signature = {
            enabled = true,
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        cmdline = {
            keymap = {
                preset = "inherit",
                ["<Enter>"] = { "fallback" },
                ["<Tab>"] = { "show", "accept" },
            },
            completion = {
                menu = {
                    auto_show = true,
                },
            },
        },
    },
}
