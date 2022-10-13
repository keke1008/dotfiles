local Filer = require("floating-fern.internal.filer")
local utils = require("floating-fern.utils")

---@type Filer?
local filer = nil

---@param action string
local function call_fern_action(action)
    vim.fn["fern#action#call"](action)

end

---@param action? string
---@param method string
---@return fun(args...: any)
local function override(action, method)
    return function(...)
        if filer then
            filer[method](filer, ...)
        elseif action then
            call_fern_action(action)
        end
    end
end

local M = {}

M.get_cursor_node = utils.get_cursor_node

function M.open()
    if not filer then
        filer = Filer.open()
        filer:on_closed(function()
            filer = nil
        end)
    end
end

---@return boolean
function M.is_open()
    return filer ~= nil
end

function M.close()
    if filer then
        filer:close()
    end
end

function M.reveal(path)
    vim.cmd("FernReveal" .. path)
end

---@type fun()
M.close = override(nil, "close")
---@type fun()
M.focus = override(nil, "focus")
---@type fun()
M.blur = override(nil, "blur")

---@type fun(close: boolean)
M.edit = override("open", "edit")
---@type fun(close: boolean)
M.split = override("open:split", "split")
---@type fun(close: boolean)
M.vsplit = override("open:vsplit", "vsplit")
---@type fun(close: boolean)
M.tabedit = override("open:tabedit", "tabedit")
---@type fun(close: boolean)
M.select = override("open:select", "select")

---@type fun()
M.rename = override("rename", "rename")

---@type fun(direction: "up" | "down", half: boolean)
M.scroll_preview = override(nil, "scroll_preview")

---@type fun()
M.telescope_find_files = override(nil, "telescope_find_files")
---@type fun()
M.telescope_live_grep = override(nil, "telescope_live_grep")

return M
