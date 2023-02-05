local noice = require("noice")
local notify = require("notify")

noice.setup({
    views = {
        cmdline_popup = {
            position = {
                row = "20%",
            },
            zindex = 100,
        },
        confirm = {
            position = {
                row = "20%",
            },
        },
        vsplit = {
            size = {
                max_width = "50%",
            },
        },
        hover = {
            border = {
                style = "rounded",
            },
            position = { row = 2 },
        },
    },
    routes = {
        {
            view = "mini",
            filter = {
                event = "msg_show",
                kind = "emsg",
                any = {
                    { find = "^E486" },
                    { find = "^E37" },
                },
            },
        },
        {
            view = "mini",
            filter = {
                any = {
                    { event = "msg_show", kind = { "echo", "echomsg", "wmsg" } },
                    { event = "notify", error = false },
                    { event = "msg_show", kind = "emsg", find = "E(486|37)" },
                },
            },
        },
        {
            view = "cmdline_output",
            filter = {
                cmdline = "^:",
                error = false,
                warning = false,
                ["not"] = { kind = { "confirm", "confirm_sub", "return_prompt" } },
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
