local wk = vim.F.npcall(require, "which-key")
local menu = require("keke.side_menu")
local remap = vim.keymap.set

remap("n", "j", "gj")
remap("n", "k", "gk")
remap("n", "<Esc>", "<CMD>write<CR>")
remap("n", "<leader><leader>", "<CMD>noh<CR>", { silent = true })
remap("s", "<BS>", "<BS>i")
remap("n", "+", ",")

remap("t", "<Esc>", "<C-\\><C-n>")

menu.remap_close("h")
menu.remap_ignore("i")
menu.remap_close_all("H")

local M = {}

---@param group table<string, string>
function M.register_group(group)
    if not wk then return end

    group = vim.tbl_map(function(name) return { name = name } end, group)
    wk.register(group)
end

local second_leader = "\\"

-- second leader key
---@param key string
---@return string
function M.l2(key) return second_leader .. key end

return M
