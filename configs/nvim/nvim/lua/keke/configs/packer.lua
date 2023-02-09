local map = require("keke.utils.mapping")

local function reload(profile)
    package.loaded["keke.plugins"] = nil
    require("keke.plugins")

    local packer = require("packer")
    packer.install()
    packer.compile(profile and "profile=true" or nil)
end

vim.api.nvim_create_user_command("PackerReload", function() reload(false) end, {})
vim.api.nvim_create_user_command("PackerReloadWithProfile", function() reload(true) end, {})

map.add_group(map.l2("pa"), "Packer")

local opts = { silent = true }
vim.keymap.set("n", map.l2("pai"), "<CMD>PackerInstall<CR>", opts)
vim.keymap.set("n", map.l2("pal"), "<CMD>PackerClean<CR>", opts)
vim.keymap.set("n", map.l2("pau"), "<CMD>PackerUpdate<CR>", opts)
vim.keymap.set("n", map.l2("pas"), "<CMD>PackerStatus<CR>", opts)
vim.keymap.set("n", map.l2("pay"), "<CMD>PackerSync<CR>", opts)
vim.keymap.set("n", map.l2("pac"), "<CMD>PackerCompile<CR>", opts)
vim.keymap.set("n", map.l2("par"), "<CMD>PackerReload<CR>", opts)
