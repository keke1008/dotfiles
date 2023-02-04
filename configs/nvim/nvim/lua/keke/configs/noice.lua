local noice = require("noice")
local notify = require("notify")

noice.setup({
    presets = {
        command_palette = true,
        cmdline_output_to_split = true,
    },
    routes = {
        {
            view = "mini",
            filter = { event = "msg_show", kind = "" },
        },
        {
            view = "mini",
            filter = { warning = true },
        },
        {
            view = "mini",
            filter = { event = "msg_show", kind = "emsg", find = "^E486:" },
        },
        {
            view = "vsplit",
            filter = { error = true, ["not"] = { find = "^E%d+:" } },
        },
        {
            view = "vsplit",
            filter = { min_height = 10 },
        },
    },
})

---@param key string
---@param cmd string | fun()
---@param desc? string
local function remap(key, cmd, desc)
    local rhs = type(cmd) == "string" and ("<CMD>Noice %s<CR>"):format(cmd) or cmd
    vim.keymap.set("n", "<leader>n" .. key, rhs, { desc = desc or cmd })
end

remap("h", "history")
remap("l", "last")
remap("t", "telescope")
remap("n", notify.dismiss, "dimiss notifications")
