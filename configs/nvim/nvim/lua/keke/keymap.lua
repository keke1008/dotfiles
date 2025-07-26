local keymap = require("keymap")
keymap.setup()

local M = {}

M.lib = keymap

function M.init()
    local function call_module(name, f, ...)
        local args = { ... }
        return function()
            require(name)[f](unpack(args))
        end
    end

    ---@param name string
    ---@param ... string
    ---@return fun(...)
    local function access_module(name, ...)
        local args = { ... }
        return function(...)
            local module = require(name)
            return vim.tbl_get(module, unpack(args))(...)
        end
    end

    keymap.add({
        mode = { "i", "s", "c" },
        { key = "<C-j>", action = call_module("luasnip", "jump", 1) },
        { key = "<C-k>", action = call_module("luasnip", "jump", -1) },
        {
            key = "<C-p>",
            {
                action = function()
                    local cmp = require("cmp")
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                end,
                when = M.helper.cmp_visible,
            },
            { action = call_module("cmp", "complete") },
        },
        {
            key = "<C-n>",
            {
                action = function()
                    local cmp = require("cmp")
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                end,
                when = M.helper.cmp_visible,
            },
            { action = call_module("cmp", "complete") },
        },
        { key = "<C-b>", action = call_module("cmp", "scroll_docs", -4), when = M.helper.cmp_visible },
        { key = "<C-f>", action = call_module("cmp", "scroll_docs", 4), when = M.helper.cmp_visible },
        {
            mode = { "i", "s" },
            key = "<CR>",
            action = call_module("cmp", "confirm"),
            when = M.helper.cmp_visible,
        },
        {
            key = "<C-e>",
            {
                action = function()
                    require("cmp").abort()
                    vim.api.nvim_input("<CR>")
                end,
                when = M.helper.cmp_visible,
            },
            { action = "<CR>" },
        },
        {
            key = "<Tab>",
            mode = "c",
            {
                action = call_module("cmp", "confirm"),
                when = M.helper.cmp_visible,
            },
            { action = call_module("cmp", "complete") },
        },
    })

    local function set_conditional_breakpoint()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
            if condition then
                require("dap").set_breakpoint(condition)
            end
        end)
    end

    keymap.add({
        mode = "n",
        { key = "<leader>db", action = call_module("dap", "toggle_breakpoint"), desc = "Toggle Breakpoint" },
        { key = "<leader>dv", action = set_conditional_breakpoint, desc = "Set Conditional Breakpoint" },
        { key = "<leader>dc", action = call_module("dap", "continue"), desc = "Continue Debugging" },
        { key = "<leader>di", action = call_module("dap", "step_into"), desc = "Step Into" },
        { key = "<leader>do", action = call_module("dap", "step_over"), desc = "Step Over" },
        { key = "<leader>dp", action = call_module("dap", "step_out"), desc = "Step Out" },
        { key = "<leader>dq", action = call_module("dap", "terminate"), desc = "Terminate Debugging" },
        { key = "<leader>dl", action = call_module("dap", "run_last"), desc = "Run Last Debug Session" },
        { key = "<leader>dk", action = call_module("dapui", "eval"), desc = "Debug Eval Expression" },
        {
            when = M.helper.dap_stopping,
            { key = "b", action = call_module("dap", "toggle_breakpoint"), desc = "Toggle Breakpoint" },
            { key = "v", action = set_conditional_breakpoint, desc = "Set Conditional Breakpoint" },
            { key = "c", action = call_module("dap", "continue"), desc = "Continue Debugging" },
            { key = "i", action = call_module("dap", "step_into"), desc = "Step Into" },
            { key = "o", action = call_module("dap", "step_over"), desc = "Step Over" },
            { key = "p", action = call_module("dap", "step_out"), desc = "Step Out" },
            { key = "q", action = call_module("dap", "terminate"), desc = "Terminate Debugging" },
            { key = "l", action = call_module("dap", "run_last"), desc = "Run Last Debug Session" },
        },
    })

    ---@param ... string
    local function nvim_tree_api(...)
        return access_module("nvim-tree.api", ...)
    end

    keymap.add({
        mode = "n",
        nowait = true,
        buffers = M.helper.nvim_tree_buffers,
        { key = "e", action = nvim_tree_api("node", "open", "edit"), desc = "edit" },
        { key = "v", action = nvim_tree_api("node", "open", "vertical"), desc = "vsplit" },
        { key = "s", action = nvim_tree_api("node", "open", "horizontal"), desc = "split" },
        { key = "t", action = nvim_tree_api("node", "open", "tab"), desc = "tab" },
        { key = "K", action = nvim_tree_api("node", "show_info_popup"), desc = "info" },
        { key = "w", action = nvim_tree_api("tree", "change_root_to_node"), desc = "enter directory" },
        { key = "b", action = nvim_tree_api("tree", "change_root_to_parent"), desc = "leave directory" },
        {
            key = "i",
            action = function()
                local api = require("nvim-tree.api")
                api.tree.toggle_gitignore_filter()
                api.tree.toggle_hidden_filter()
            end,
            desc = "toggle gitignore and hidden files",
        },
        { key = "<C-r>", action = nvim_tree_api("tree", "reload"), desc = "reload" },
        { key = "r", action = nvim_tree_api("fs", "rename"), desc = "rename" },
        { key = "c", action = nvim_tree_api("fs", "create"), desc = "create" },
        { key = "d", action = nvim_tree_api("fs", "remove"), desc = "remove" },
        { key = "y", action = nvim_tree_api("fs", "copy", "node"), desc = "copy" },
        { key = "p", action = nvim_tree_api("fs", "paste"), desc = "paste" },
        {
            key = "o",
            action = function()
                local node = require("nvim-tree.api").tree.get_node_under_cursor()
                if node.name == ".." then
                    vim.cmd.Oil(node.explorer.absolute_path)
                elseif node.type == "directory" then
                    vim.cmd.Oil(node.absolute_path)
                elseif node.type == "file" then
                    vim.cmd.Oil(vim.fn.fnamemodify(node.absolute_path, ":p:h"))
                else
                    vim.notify("Unsupported node type: " .. node.type, vim.log.levels.WARN)
                end
            end,
            desc = "open in Oil",
        },
    })

    keymap.add({
        mode = "n",
        { key = "<leader>fr", action = "<CMD>Telescope resume<CR>" },
        { key = "<leader>fb", action = "<CMD>Telescope buffers<CR>" },
        {
            key = "<leader>ff",
            action = call_module("telescope.builtin", "find_files", { hidden = true }),
            desc = "find files",
        },
        {
            key = "<leader>fF",
            action = call_module(
                "telescope.builtin",
                "find_files",
                { hidden = true, no_ignore = true, no_ignore_parent = true }
            ),
            desc = "find hidden files",
        },
        { key = "<leader>fh", action = "<CMD>Telescope help_tags<CR>" },
        { key = "<leader>fm", action = "<CMD>Telescope marks<CR>" },
        { key = "<leader>fl", action = "<CMD>Telescope live_grep<CR>" },
        {
            key = "<leader>fL",
            action = call_module("telescope.builtin", "live_grep", { additional_args = { "--hidden" } }),
            desc = "live grep hidden files",
        },
        { key = "<leader>fgf", action = "<CMD>Telescope git_files<CR>" },
        { key = "<leader>fgc", action = "<CMD>Telescope git_commits<CR>" },
        { key = "<leader>fgC", action = "<CMD>Telescope git_bcommits<CR>", desc = "commits for current buffer" },
        { key = "<leader>fgb", action = "<CMD>Telescope git_branches<CR>" },
        { key = "<leader>fgs", action = "<CMD>Telescope git_status<CR>" },
        { key = "<leader>fgh", action = "<CMD>Telescope git_stash<CR>" },
    })

    local function telescope_action(name)
        return function()
            return require("telescope.actions")[name](vim.api.nvim_get_current_buf())
        end
    end

    keymap.add({
        mode = "i",
        buffers = M.lib.preset.buffers.filetype("TelescopePrompt"),
        { key = "<C-b>", action = telescope_action("preview_scrolling_up") },
        { key = "<C-f>", action = telescope_action("preview_scrolling_down") },
    })

    keymap.add({
        buffers = M.helper.git_buffers,
        {
            mode = { "n", "x", "o" },
            { key = "[g", action = "<CMD>Gitsigns prev_hunk<CR>" },
            { key = "]g", action = "<CMD>Gitsigns next_hunk<CR>" },
        },
        {
            mode = "n",
            { key = "<leader>gs", action = "<CMD>Gitsigns stage_hunk<CR>" },
            { key = "<leader>gr", action = "<CMD>Gitsigns reset_hunk<CR>" },
            { key = "<leader>gu", action = "<CMD>Gitsigns undo_stage_hunk<CR>" },
            { key = "<leader>gS", action = "<CMD>Gitsigns stage_buffer<CR>" },
            { key = "<leader>gR", action = "<CMD>Gitsigns reset_buffer<CR>" },
            { key = "<leader>gp", action = "<CMD>Gitsigns preview_hunk<CR>" },
            { key = "<leader>gd", action = "<CMD>Gitsigns diffthis<CR>" },
            { key = "<leader>gb", action = "<CMD>Gitsigns blame_line<CR>" },
        },
    })

    keymap.add({
        mode = "n",
        { key = "gd", action = vim.lsp.buf.definition },
        { key = "gD", action = vim.lsp.buf.declaration },
        { key = "gt", action = vim.lsp.buf.type_definition },
        { key = "gi", action = vim.lsp.buf.implementation },
        { key = "gr", action = vim.lsp.buf.references },
        { key = "K", action = vim.lsp.buf.hover },
        { key = "[e", action = "<CMD>Lspsaga diagnostic_jump_prev<CR>" },
        { key = "]e", action = "<CMD>Lspsaga diagnostic_jump_next<CR>" },
        { key = "<leader>ld", action = "<CMD>Lspsaga peek_definition<CR>" },
        { key = "<leader>la", action = "<CMD>Lspsaga code_action<CR>" },
        { key = "<leader>ll", action = vim.lsp.codelens.run },
        { key = "<leader>lr", action = "<CMD>Lspsaga rename<CR>" },
        { key = "<leader>li", action = vim.lsp.buf.incoming_calls },
        { key = "<leader>lo", action = vim.lsp.buf.outgoing_calls },
    })
end

---@class KeymapHelper
---@field cmp_visible keymap.Condition
---@field dap_stopping keymap.Condition
---@field nvim_tree_buffers keymap.BufferSet
---@field git_buffers keymap.BufferSet
---@field lsp_attached_buffers keymap.BufferSet
M.helper = {}

return M
