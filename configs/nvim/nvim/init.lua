_G.is_in_terminal = (not vim.g.vscode) and not vim.g.started_by_firenvim

vim.o.number = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.signcolumn = "yes"
vim.o.scrolloff = 5

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
vim.o.completeopt = "menuone,noinsert"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.updatetime = 300
vim.o.timeoutlen = 500

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.go", "*.sh" },
    callback = function() vim.bo.expandtab = false end,
})

vim.g.mapleader = " "
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Esc>", "<CMD>write<CR>")
vim.keymap.set("s", "<BS>", "<BS>i")
vim.keymap.set("n", "+", ",")
vim.keymap.set("n", "[c", "<CMD>cp<CR>")
vim.keymap.set("n", "]c", "<CMD>cn<CR>")
vim.keymap.set("n", "[b", "<CMD>bp<CR>")
vim.keymap.set("n", "]b", "<CMD>bn<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.diagnostic.config({ severity_sort = true })

local drawer = require("drawer")
drawer.setup({ prefix_key = "<leader>s" })
vim.keymap.set(
    "n",
    drawer.with_prefix_key("hl"),
    function() drawer.close_by_position("left") end,
    { desc = "close left drawer" }
)
vim.keymap.set(
    "n",
    drawer.with_prefix_key("hr"),
    function() drawer.close_by_position("right") end,
    { desc = "close right drawer" }
)
vim.keymap.set(
    "n",
    drawer.with_prefix_key("hb"),
    function() drawer.close_by_position("bottom") end,
    { desc = "close bottom drawer" }
)
vim.keymap.set("n", drawer.with_prefix_key("H"), drawer.close_all, { desc = "close all drawers" })

-- Set clipboard configs manually
require("keke.clipboard")

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

vim.api.nvim_create_user_command("WipeInvisibleBuffers", function()
    local buffer_infos = vim.fn.getbufinfo({ buflisted = true }) or {}

    for _, buffer_info in ipairs(buffer_infos) do
        if buffer_info.changed == 0 and #buffer_info.windows == 0 then
            vim.api.nvim_buf_delete(buffer_info.bufnr, { force = false, unload = false })
        end
    end
end, { desc = "Wipe invisible buffers" })

if vim.g.vscode then
    require("keke.vscode")
end

require("keke.lazy")
