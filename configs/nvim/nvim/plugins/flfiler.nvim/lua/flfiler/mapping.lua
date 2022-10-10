local global = require("flfiler.global")

---@param action FilerActionKind
---@param param? table
---@param fallback_arg? unknown
---@return function
local function fallback(action, param, fallback_arg)
    ---@type FlfilerMessage.FilerAction
    local message = param or {}
    message.type = "filer_action"
    message.action = action

    return function()
        local flfiler = global.get_flfiler()
        if flfiler:is_open() then
            return flfiler:publish(message)
        else
            flfiler:filer()[action](fallback_arg)
        end
    end
end

local M = {}

---@param path? string
function M.launch(path)
    global.get_flfiler():open(path or vim.fn.getcwd())
end

function M.focus()
    global.get_flfiler():focus()
end

---@param path? string
---@return fun()
function M.focus_or_launch(path)
    return function()
        local flfiler = global.get_flfiler()
        if flfiler:is_open() then
            M.focus()
        else
            M.launch(path)
        end
    end
end

function M.blur()
    global.get_flfiler():blur()
end

function M.close()
    global.get_flfiler():close()
end

---@param remain_cursor boolean
---@return fun()
function M.edit(remain_cursor)
    return fallback("edit", { remain_cursor = remain_cursor })
end

---@param remain_cursor boolean
---@return fun()
function M.split(remain_cursor)
    return fallback("split", { remain_cursor = remain_cursor })
end

---@param remain_cursor boolean
---@return fun()
function M.vsplit(remain_cursor)
    return fallback("vsplit", { remain_cursor = remain_cursor })
end

---@param remain_cursor boolean
---@return fun()
function M.tabedit(remain_cursor)
    return fallback("tabedit", { remain_cursor = remain_cursor })
end

---@param remain_cursor boolean
---@return fun()
function M.select(remain_cursor)
    return fallback("select", { remain_cursor = remain_cursor })
end

M.expand = fallback("expand")
M.collapse = fallback("collapse")
M.enter = fallback("enter")
M.leave = fallback("leave")
M.rename = fallback("rename")
M.delete = fallback("delete")
M.mark = fallback("mark")

function M.scroll_up_preview()
    global.get_flfiler():publish({
        type = "scroll_preview",
        direction = "up",
        half = false,
    })
end

function M.scroll_up_preview_half()
    global.get_flfiler():publish({
        type = "scroll_preview",
        direction = "up",
        half = true,
    })
end

function M.scroll_down_preview()
    global.get_flfiler():publish({
        type = "scroll_preview",
        direction = "down",
        half = false,
    })
end

function M.scroll_down_preview_half()
    global.get_flfiler():publish({
        type = "scroll_preview",
        direction = "down",
        half = true,
    })
end

---@param file fun()
---@param expanded fun()
---@param collapsed? fun(): fun()
---@return fun()
function M.switch(file, expanded, collapsed)
    return function()
        local node = global.get_flfiler():filer():cursor_node()
        if node.type == "file" then
            file()
            return
        end

        if node.expanded or not collapsed then
            expanded()
            return
        end

        collapsed()
    end
end

function M.expand_or_collapse()
    return M.switch(function() end, M.collapse, M.expand)()
end

return M
