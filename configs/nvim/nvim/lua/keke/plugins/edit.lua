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
            { "kana/vim-textobj-user", cond = true }
        },
    },
    {
        "junegunn/vim-easy-align",
        keys = {
            { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "easy align" },
        }
    },
    {
        "ggandor/leap.nvim",
        cond = true,
        keys = function()
            local function leap_tabpage()
                require("leap").leap({
                    target_windows = vim.tbl_filter(
                        function(win) return vim.api.nvim_win_get_config(win).focusable end,
                        vim.api.nvim_tabpage_list_wins(0)
                    ),
                })
            end
            return {
                { ",",     leap_tabpage, mode = { "n", "x" }, desc = "leap tabpage" },
                { "<C-l>", leap_tabpage, mode = { "i", "s" }, desc = "leap tabpage" },
            }
        end
    },
    {
        "haya14busa/vim-edgemotion",
        cond = true,
        keys = {
            { "<C-n>", "<Plug>(edgemotion-j)", mode = { "n", "x", "o" } },
            { "<C-p>", "<Plug>(edgemotion-k)", mode = { "n", "x", "o" } },
        }
    },
    {
        "numToStr/Comment.nvim",
        cond = true,
        keys = {
            { "gc", mode = { "n", "x" } }
        },
        config = true,
    },
    {
        "windwp/nvim-autopairs",
        cond = true,
        event = "InsertEnter",
        config = true,
    },
    {
        "haya14busa/vim-asterisk",
        cond = true,
        keys = {
            { "*",  "<Plug>(asterisk-z*)",  mode = { "n", "x" } },
            { "#",  "<Plug>(asterisk-z#)",  mode = { "n", "x" } },
            { "g*", "<Plug>(asterisk-gz*)", mode = { "n", "x" } },
            { "g#", "<Plug>(asterisk-gz#)", mode = { "n", "x" } },
        }
    },
    {
        "monaqa/dial.nvim",
        cond = true,
        keys = {
            { "<C-a>",  "<Plug>(dial-increment)",  mode = { "n" } },
            { "<C-x>",  "<Plug>(dial-decrement)",  mode = { "n" } },
            { "g<C-a>", "g<Plug>(dial-increment)", mode = { "n" } },
            { "g<C-x>", "g<Plug>(dial-decrement)", mode = { "n" } },
            { "<C-a>",  "<Plug>(dial-increment)",  mode = { "v" } },
            { "<C-x>",  "<Plug>(dial-decrement)",  mode = { "v" } },
            { "g<C-a>", "g<Plug>(dial-increment)", mode = { "v" } },
            { "g<C-x>", "g<Plug>(dial-decrement)", mode = { "v" } },
        },
        config = function()
            local augend = require("dial.augend")
            local config = require("dial.config")
            config.augends:register_group({
                default = {
                    augend.integer.alias.decimal,
                    augend.integer.alias.hex,
                    augend.constant.alias.bool,
                    augend.date.alias["%Y/%m/%d"],
                    augend.date.alias["%Y-%m-%d"],
                    augend.date.alias["%H:%M:%S"],
                    augend.constant.alias.ja_weekday,
                },
            })
        end
    },
    {
        "gbprod/substitute.nvim",
        cond = true,
        keys = function()
            local function substitute(command)
                return function() require("substitute")[command]() end
            end
            return {
                { map.l2("su"),  substitute("operator"), mode = { "n" }, desc = "substitute" },
                { map.l2("suu"), substitute("line"),     mode = { "n" }, desc = "substitute line" },
                { map.l2("sU"),  substitute("eol"),      mode = { "n" }, desc = "substitute eol" },
                { map.l2("su"),  substitute("visual"),   mode = { "x" }, desc = "substitute" },
            }
        end
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
            { drawer.with_prefix_key("u"), function() drawer.open("undotree") end, desc = "open undotree" }
        },
    },
    {
        "potamides/pantran.nvim",
        cmd = "Pantran",
        keys = function()
            local function motion_translate()
                require("pantran").motion_translate({ mode = "hover" })
            end
            return {
                { map.l2("tr"),  motion_translate,   mode = { "n" }, desc = "translate" },
                { map.l2("trr"), map.l2("tr_"),      mode = { "n" }, desc = "translate line" },
                { map.l2("tR"),  map.l2("tr$"),      mode = { "n" }, desc = "translate eol" },
                { map.l2("tro"), "<CMD>Pantran<CR>", mode = { "n" }, desc = "open pantran" },
                { map.l2("tr"),  motion_translate,   mode = { "x" }, desc = "translate" },
            }
        end,
        opts = function()
            local actions = require("pantran.ui.actions")
            return {
                default_engine = "google",
                controls = {
                    mappings = {
                        edit = {
                            n = { ["<C-s>"] = actions.switch_languages },
                            i = { ["<C-s>"] = actions.switch_languages },
                        },
                    },
                },
                engines = {
                    google = { fallback = { default_target = "ja" } },
                },
                window = {
                    window_config = { border = "rounded" },
                    options = { winhighlight = "" },
                },
            }
        end
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = "ToggleTerm",
        keys = {
            { map.l2("te"), "<CMD>ToggleTerm<CR>", mode = { "n" }, desc = "toggle terminal" },
        },
        opts = {
            direction = "float",
            float_opts = { border = "rounded" },
            highlights = { FloatBorder = { link = "FloatBorder" } },
        }
    },
    {
        "Shatur/neovim-session-manager",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = function()
            local AutoloadMode = require("session_manager.config").AutoloadMode
            return {
                autoload_mode = AutoloadMode.CurrentDir,
                autosave_ignore_filetypes = { "gitcommit", "NvimTree" },
            }
        end
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
            { drawer.with_prefix_key("o"), function() drawer.open("overseer") end, desc = "open overseer" },
            { map.l2("ovr"),               "<CMD>OverseerRun<CR>",                 mode = { "n" } },
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
                desc = "restart last task"
            },
        },
        opts = { templates = { "builtin", "keke" } }
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = "MarkdownPreview",
        config = function()
            vim.api.nvim_create_user_command(
                "MarkdownPreviewInstall",
                function() vim.fn["mkdp#util#install"]() end,
                { desc = "Install markdown-preview.nvim" }
            )
        end,
    },
    {
        "glacambre/firenvim",
        lazy = not vim.g.started_by_firenvim,
        cond = vim.g.started_by_firenvim,
        config = function()
            vim.api.nvim_create_user_command("FirenvimInstall", function()
                vim.fn["firenvim#install"](0)
            end, { desc = "Install firenvim" })
        end
    }
}
