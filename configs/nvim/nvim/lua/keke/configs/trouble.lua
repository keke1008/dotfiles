local trouble = require("trouble")
local sidemenu = require("keke.sidemenu")
local remap = vim.keymap.set

trouble.setup({
    position = "left",
    action_keys = {
        open_split = "s",
        open_vsplit = "v",
        open_tab = "t",
        toggle_fold = "e",
    },
})

---@param provider string
---@return fun()
local function open_trouble_lazy(provider)
    return function() trouble.open(provider) end
end

remap("n", "<leader>tt", trouble.open)
remap("n", "<leader>td", open_trouble_lazy("lsp_definitions"))
remap("n", "<leader>tD", open_trouble_lazy("lsp_type_definitions"))
remap("n", "<leader>tr", open_trouble_lazy("lsp_references"))
remap("n", "<leader>ti", open_trouble_lazy("lsp_implementations"))
remap("n", "<leader>tq", open_trouble_lazy("quickfix"))
remap("n", "<leader>tl", open_trouble_lazy("loclist"))
remap("n", "<leader>tw", open_trouble_lazy("workspace_diagnostics"))

sidemenu.register("t", {
    open = trouble.open,
    close = trouble.close,
})
