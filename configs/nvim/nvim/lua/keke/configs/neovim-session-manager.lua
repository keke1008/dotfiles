local session_manager = require("session_manager")
local AutoloadMode = require("session_manager.config").AutoloadMode
local keymap = require("keke.keymap")
local l2 = keymap.l2
local register_group = keymap.register_group

session_manager.setup({
    autoload_mode = AutoloadMode.CurrentDir,
    autosave_ignore_filetypes = {
        "gitcommit",
        "NvimTree",
    },
})

register_group({ [l2("se")] = "SessionManager" })

---@param key string
---@param sub_cmd string
local function remap(key, sub_cmd)
    local cmd = ("<CMD>SessionManager %s<CR>"):format(sub_cmd)
    vim.keymap.set("n", l2(key), cmd, { desc = sub_cmd })
end

remap("sea", "load_session")
remap("sep", "load_last_session")
remap("sel", "load_current_dir_session")
remap("ses", "save_current_session")
remap("sed", "delete_session")
