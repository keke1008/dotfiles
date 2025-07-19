vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 5
vim.o.fillchars = "eob: "

vim.o.cmdheight = 2
vim.o.laststatus = 3
vim.o.showcmd = true

vim.o.fenc = "utf-8"
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.hidden = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.o.smartindent = true
vim.o.completeopt = "menuone"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.updatetime = 300
vim.o.timeoutlen = 500

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "go", "sh", "bash", "zsh", "asm", "nix" },
    callback = function(args)
        vim.api.nvim_set_option_value("expandtab", false, {
            buf = args.bufnr,
        })
    end,
})

vim.g.mapleader = " "
vim.keymap.set("n", "<Esc>", "<CMD>write<CR>")
vim.keymap.set("s", "<BS>", "<BS>i")
vim.keymap.set("n", "+", ",")
vim.keymap.set("n", "[c", "<CMD>cp<CR>")
vim.keymap.set("n", "]c", "<CMD>cn<CR>")
vim.keymap.set("n", "[b", "<CMD>bp<CR>")
vim.keymap.set("n", "]b", "<CMD>bn<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set({ "n", "x" }, "j", function()
    if vim.v.count == 0 then
        return "gj"
    else
        return "j"
    end
end, { desc = "Down", expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
    if vim.v.count == 0 then
        return "gk"
    else
        return "k"
    end
end, { desc = "Up", expr = true })

vim.diagnostic.config({ severity_sort = true })

local drawer = require("drawer")
drawer.setup({ prefix_key = "<leader>s" })
vim.keymap.set("n", drawer.with_prefix_key("hl"), function()
    drawer.close_by_position("left")
end, { desc = "close left drawer" })
vim.keymap.set("n", drawer.with_prefix_key("hr"), function()
    drawer.close_by_position("right")
end, { desc = "close right drawer" })
vim.keymap.set("n", drawer.with_prefix_key("hb"), function()
    drawer.close_by_position("bottom")
end, { desc = "close bottom drawer" })
vim.keymap.set("n", drawer.with_prefix_key("H"), drawer.close_all, { desc = "close all drawers" })

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN] = "󰀪",
            [vim.diagnostic.severity.INFO] = "󰋽",
            [vim.diagnostic.severity.HINT] = "󰌶",

        },
    }
})


-- Set clipboard configs manually
require("keke.clipboard")

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank({ timeout = 200 })
    end,
})

local function set_relativenumber(value)
    return function()
        local is_number_shown = vim.api.nvim_get_option_value("number", {})
        if is_number_shown then
            vim.api.nvim_set_option_value("relativenumber", value, {})
        end
    end
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
    callback = set_relativenumber(false),
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
    callback = set_relativenumber(true),
})

vim.api.nvim_create_user_command("W", function(opt)
    local cmd = opt.bang and "w!" or "w"
    vim.cmd("noautocmd " .. cmd)
end, { bang = true, desc = "Write the buffer without autocmd" })

if vim.g.vscode then
    require("keke.vscode")
end

vim.filetype.add({
    filename = {
        [".shrc"] = "sh",
        [".bashrc"] = "bash",
        [".bash_profile"] = "bash",
    },
})

require("keke.lazy")

require("keke.keymap")
