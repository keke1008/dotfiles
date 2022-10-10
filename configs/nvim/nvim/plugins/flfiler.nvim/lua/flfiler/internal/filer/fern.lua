local AbstractFiler = require("flfiler.internal.filer")
local utils = require("flfiler.utils")
local global = require("flfiler.global")

vim.api.nvim_create_autocmd('Filetype', {
    pattern = "fern",
    callback = function(e)
        vim.api.nvim_buf_set_option(e.buf, "bufhidden", "wipe")
    end
})

---@return any
local function call_fern_helper(property)
    local expr = string.format("fern#helper#call({ helper -> helper.%s() })", property)
    return vim.api.nvim_eval(expr)
end

---@class FernFiler: AbstractFiler
local FernFiler = setmetatable({}, AbstractFiler)
FernFiler.__index = FernFiler

---@param path string
function FernFiler.open(path)
    vim.cmd("Fern " .. path)
end

function FernFiler.close()
    vim.api.nvim_win_close(0, true)
end

---@param action string
---@return fun()
local function call_fern_action_lazy(action)
    return function()
        vim.fn["fern#action#call"](action)
    end
end

local api_list = {
    edit = "open",
    split = "open:split",
    vsplit = "open:vsplit",
    tabedit = "open:tabedit",
    select = "open:select",
    expand = "expand",
    collapse = "collapse",
    enter = "enter",
    leave = "leave",
    delete = "remove",
    mark = "mark:toggle",
}
for key, action in pairs(api_list) do
    FernFiler[key] = call_fern_action_lazy(action)
end

function FernFiler.rename()
    call_fern_action_lazy("rename")()
    local bufnr = vim.api.nvim_get_current_buf()
    local renamer_winid = utils.open_window(global.get_config().layout.rename())
    vim.api.nvim_win_set_buf(renamer_winid, bufnr)
    vim.api.nvim_win_close(0, true)
    vim.api.nvim_set_current_win(renamer_winid)
end

---@return EntryNode
function FernFiler.cursor_node()
    local node = call_fern_helper("sync.get_cursor_node")
    if node.status == vim.g["fern#STATUS_NONE"] then
        return {
            type = "file",
            path = node._path
        }
    end

    return {
        type = "directory",
        path = node._path,
        expanded = node.status == vim.g["fern#STATUS_EXPANDED"]
    }
end

---@param path string
function FernFiler.reveal(path)
    vim.cmd("FernReveal " .. path)
end

return FernFiler
