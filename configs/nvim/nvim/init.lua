vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
vim.g.did_indent_on = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_man = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.skip_loading_mswin = 1

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
vim.o.list = true

vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.completeopt = "menuone,noinsert"
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.updatetime = 300
vim.o.timeoutlen = 500

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.g.mapleader = " "
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Esc>", "<CMD>write<CR>")
vim.keymap.set("s", "<BS>", "<BS>i")
vim.keymap.set("n", "+", ",")
vim.keymap.set("n", "[c", "<CMD>cp<CR>")
vim.keymap.set("n", "]c", "<CMD>cn<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

local drawer = require("drawer")
drawer.setup({ prefix_key = "<leader>s" })
vim.keymap.set("n", drawer.with_prefix_key("hl"), function() drawer.close_by_position("left") end,
    { desc = "close left drawer" });
vim.keymap.set("n", drawer.with_prefix_key("hr"), function() drawer.close_by_position("right") end,
    { desc = "close right drawer" });
vim.keymap.set("n", drawer.with_prefix_key("hb"), function() drawer.close_by_position("bottom") end,
    { desc = "close bottom drawer" });
vim.keymap.set("n", drawer.with_prefix_key("H"), drawer.close_all, { desc = "close all drawers" });


-- Set clipboard configs manually
require("keke.clipboard")

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

vim.api.nvim_create_user_command("WipeInvisibleBuffers", function()
    local buffer_infos = vim.fn.getbufinfo({ buflisted = true }) or {}

    for _, buffer_info in ipairs(buffer_infos) do
        if buffer_info.changed == 0 and #buffer_info.windows == 0 then
            vim.api.nvim_buf_delete(buffer_info.bufnr, { force = false, unload = false })
        end
    end
end, { desc = "Wipe invisible buffers" })

-- require("keke.plugins")
require("keke.lazy")
