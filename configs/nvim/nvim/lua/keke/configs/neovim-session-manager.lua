local session_manager = require("session_manager")
local AutoloadMode = require("session_manager.config").AutoloadMode
local utils = require("session_manager.utils")
local map = require("keke.utils.mapping")

vim.opt_global.sessionoptions:append("tabpages");

-- HACK: Let plugin know that help buffer can be restored if 'sessionoptions' include 'help'.
(function()
    local original = utils.is_restorable

    ---@diagnostic disable-next-line: duplicate-set-field
    utils.is_restorable = function(buffer, ...)
        local sessionoptions = vim.opt.sessionoptions:get()
        if not vim.tbl_contains(sessionoptions, "help") then return original(buffer, ...) end

        local buftype = vim.api.nvim_buf_get_option(buffer, "buftype")
        return buftype == "help" or original(buffer, ...)
    end
end)()

session_manager.setup({
    autoload_mode = AutoloadMode.CurrentDir,
    autosave_ignore_filetypes = {
        "gitcommit",
        "NvimTree",
    },
})

map.add_group(map.l2("se"), "SessionManager")

vim.keymap.set("n", map.l2("sea"), "<CMD>SessionManager load_session<CR>")
vim.keymap.set("n", map.l2("sep"), "<CMD>SessionManager load_last_session<CR>")
vim.keymap.set("n", map.l2("sel"), "<CMD>SessionManager load_current_dir_session<CR>")
vim.keymap.set("n", map.l2("ses"), "<CMD>SessionManager save_current_session<CR>")
vim.keymap.set("n", map.l2("sed"), "<CMD>SessionManager delete_session<CR>")
