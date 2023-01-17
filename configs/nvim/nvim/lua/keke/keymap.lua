local menu = require("keke.side_menu")
local remap = vim.keymap.set

remap({ "n", "v", "t", "l" }, "t", "<one-shot-leader>", { remap = true })

local function compress(key)
    local prefix = "m"
    local targets = { key, ("<S-%s>"):format(key), ("<C-%s>"):format(key), ("<M-%s>"):format(key) }
    for _, target in ipairs(targets) do
        remap({ "n", "v", "o", "t", "l" }, prefix .. target, target)
    end
end

compress("q")
compress("r")
compress("t")
compress("@")
compress("m")

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
