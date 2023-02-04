local noice = require("noice")
local notify = require("notify")

noice.setup({
    presets = {
        command_palette = true,
    },
    routes = {
        {
            view = "mini",
            filter = {
                event = "msg_show",
                any = {
                    { kind = "" },
                    { error = false },
                    { kind = "emsg", find = "^E486:" },
                    { kind = { "echo", "emsg" }, find = "E37" },
                },
            },
        },
        {
            view = "mini",
            filter = { event = "notify", error = false },
        },
        {
            view = "cmdline_output",
            filter = {
                cmdline = "^:",
                error = false,
                warning = false,
            },
        },
        {
            view = "vsplit",
            filter = {
                any = {
                    { error = true, ["not"] = { find = "^E%d+:" } },
                    { min_height = 10, ["not"] = { event = "lsp" } },
                },
            },
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
