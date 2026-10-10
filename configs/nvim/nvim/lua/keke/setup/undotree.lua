local drawer = require("drawer")

local function call()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open({ command = "topleft 40vnew" })
end

drawer.register({
    name = "undotree",
    positions = { "left" },
    open = call,
    close = call,
})

vim.keymap.set("n", "<leader>su", function()
    drawer.open("undotree")
end, { desc = "open undotree" })
