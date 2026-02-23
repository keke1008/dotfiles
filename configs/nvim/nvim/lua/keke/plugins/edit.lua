---@diagnostic disable: missing-fields
local map = require("keke.utils.mapping")
local drawer = require("drawer")

return {
    {
        "tpope/vim-repeat",
        cond = true,
        lazy = false,
    },
    {
        "kylechui/nvim-surround",
        cond = true,
        event = "VeryLazy",
        config = true,
    },
    {
        "sgur/vim-textobj-parameter",
        cond = true,
        event = "VeryLazy",
        dependencies = {
            { "kana/vim-textobj-user", cond = true },
        },
    },
    {
        "junegunn/vim-easy-align",
        keys = {
            { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "easy align" },
        },
    },
    {
        "https://codeberg.org/andyg/leap.nvim",
        cond = true,
        dependencies = {
            "tpope/vim-repeat",
        },
        keys = function()
            local function leap_tabpage()
                require("leap").leap({
                    target_windows = vim.tbl_filter(function(win)
                        return vim.api.nvim_win_get_config(win).focusable
                    end, vim.api.nvim_tabpage_list_wins(0)),
                })
            end
            return {
                { ",", leap_tabpage, mode = { "n", "x", "o" }, desc = "leap tabpage" },
                { "<C-l>", leap_tabpage, mode = { "i", "s" }, desc = "leap tabpage" },
            }
        end,
    },
    {
        "haya14busa/vim-edgemotion",
        cond = true,
        keys = {
            { "<C-n>", "<Plug>(edgemotion-j)", mode = { "n", "x", "o" } },
            { "<C-p>", "<Plug>(edgemotion-k)", mode = { "n", "x", "o" } },
        },
    },
    {
        "numToStr/Comment.nvim",
        cond = true,
        keys = {
            { "gc", mode = { "n", "x" } },
        },
        config = true,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "haya14busa/vim-asterisk",
        keys = {
            { "*", "<Plug>(asterisk-z*)", mode = { "n", "x" } },
            { "#", "<Plug>(asterisk-z#)", mode = { "n", "x" } },
            { "g*", "<Plug>(asterisk-gz*)", mode = { "n", "x" } },
            { "g#", "<Plug>(asterisk-gz#)", mode = { "n", "x" } },
        },
    },
    {
        "gbprod/substitute.nvim",
        cond = true,
        keys = function()
            local function substitute(command)
                return function()
                    require("substitute")[command]()
                end
            end
            return {
                { map.l2("su"), substitute("operator"), mode = { "n" }, desc = "substitute" },
                { map.l2("suu"), substitute("line"), mode = { "n" }, desc = "substitute line" },
                { map.l2("sU"), substitute("eol"), mode = { "n" }, desc = "substitute eol" },
                { map.l2("su"), substitute("visual"), mode = { "x" }, desc = "substitute" },
            }
        end,
        config = true,
    },
    {
        "mbbill/undotree",
        cmd = "Undotree",
        init = function()
            drawer.register({
                name = "undotree",
                positions = { "left" },
                open = "UndotreeShow | UndotreeFocus",
                close = "UndotreeHide",
            })
        end,
        keys = {
            {
                drawer.with_prefix_key("u"),
                function()
                    drawer.open("undotree")
                end,
                desc = "open undotree",
            },
        },
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = "ToggleTerm",
        keys = {
            {
                map.l2("te"),
                function()
                    local terminals = require("toggleterm.terminal")

                    local float_or_hidden_term = vim.iter(terminals.get_all(true))
                        :filter(function(term)
                            return term:is_float() or not term:is_open()
                        end)
                        :next()
                    if float_or_hidden_term == nil then
                        terminals.Terminal:new():open()
                    else
                        float_or_hidden_term:toggle()
                    end
                end,
                desc = "Toggle Terminal",
            },
        },
        opts = {
            direction = "float",
            float_opts = { border = "rounded" },
            highlights = { FloatBorder = { link = "FloatBorder" } },
        },
    },
    {
        "Shatur/neovim-session-manager",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        lazy = false,
        config = function()
            local session_manager = require("session_manager")
            local config = require("session_manager.config")
            session_manager.setup({
                autoload_mode = config.AutoloadMode.CurrentDir,
            })
        end,
    },
    {
        "stevearc/overseer.nvim",
        cmd = "Overseer",
        init = function()
            drawer.register({
                name = "overseer",
                positions = { "right" },
                open = "OverseerOpen right",
                close = "OverseerClose",
            })
        end,
        keys = {
            {
                drawer.with_prefix_key("o"),
                function()
                    drawer.open("overseer")
                end,
                desc = "open overseer",
            },
            { map.l2("ovr"), "<CMD>OverseerRun<CR>", mode = { "n" } },
            {
                map.l2("ovl"),
                function()
                    local overseer = require("overseer")
                    local tasks = overseer.list_tasks({ recent_first = true })
                    if vim.tbl_isempty(tasks) then
                        vim.notify("No task found", vim.log.levels.WARN)
                    else
                        overseer.run_action(tasks[1], "restart")
                    end
                end,
                mode = { "n" },
                desc = "restart last task",
            },
        },
        opts = { templates = { "builtin", "keke" } },
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = "MarkdownPreview",
        config = function()
            vim.api.nvim_create_user_command("MarkdownPreviewInstall", function()
                vim.fn["mkdp#util#install"]()
            end, { desc = "Install markdown-preview.nvim" })
        end,
    },
    {
        "itchyny/vim-qfedit",
        event = "QuickFixCmdPre",
    },
    {
        "kevinhwang91/nvim-bqf",
        ft = { "qf" },
        config = function()
            require("bqf").setup({
                preview = {
                    winblend = 0,
                },
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "qf",
                callback = function(opts)
                    vim.keymap.set("n", "q", "<CMD>cclose<CR>", { buffer = opts.buf })
                end,
            })
        end,
    },
    {
        "michaelb/sniprun",
        cmd = { "SnipRun", "SnipInfo" },
        init = function()
            vim.api.nvim_create_user_command("SnipRunInstall", function()
                local path = "~/.local/share/nvim/lazy/sniprun/install.sh"
                vim.fn.system({ "sh", path })
            end, { desc = "Install sniprun" })
        end,
    },
    {
        "uga-rosa/ccc.nvim",
        event = "BufEnter",
        opts = { highlighter = { auto_enable = true } },
    },
    {
        "nvimtools/hydra.nvim",
    },
    {
        "NMAC427/guess-indent.nvim",
        lazy = false,
        config = true,
    },
}
