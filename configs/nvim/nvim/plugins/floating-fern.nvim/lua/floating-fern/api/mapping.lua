local functions = require("floating-fern.api.functions")

---@param action string
local function call_fern_action(action)
    vim.fn["fern#action#call"](action)
end

---@generic T
---@param f fun(args...: T)
---@param ... T
---@return fun()
local function bind(f, ...)
    local args = { ... }
    return function()
        f(unpack(args))
    end
end

local M = {}

M.open = functions.open
M.close = functions.close
M.focus = functions.focus
M.blur = functions.blur

M.edit = bind(functions.edit, true)
M.edit_stay = bind(functions.edit, false)
M.split = bind(functions.split, true)
M.split_stay = bind(functions.split, false)
M.vsplit = bind(functions.vsplit, true)
M.vsplit_stay = bind(functions.vsplit, false)
M.tabedit = bind(functions.tabedit, true)
M.tabedit_stay = bind(functions.tabedit, false)
M.select = bind(functions.select, true)
M.select_stay = bind(functions.select, false)

M.rename = functions.rename

M.scroll_preview_up = bind(functions.scroll_preview, "up", false)
M.scroll_preview_up_half = bind(functions.scroll_preview, "up", true)
M.scroll_preview_down = bind(functions.scroll_preview, "down", false)
M.scroll_preview_down_half = bind(functions.scroll_preview, "down", true)

M.telescope_find_files = functions.telescope_find_files
M.telescope_live_grep = functions.telescope_live_grep

---@param action string
---@return fun()
function M.action(action)
    return function()
        call_fern_action(action)
    end
end

---@param action string | fun()
local function execute_action(action)
    if type(action) == "string" then
        call_fern_action(action)
    else
        action()
    end
end

---@param leaf string | fun() | nil
---@param expanded string | fun() | nil
---@param collapsed? string | fun()
---@return fun()
function M.smart_leaf(leaf, expanded, collapsed)
    return function()
        local node = functions.get_cursor_node()

        if node.type == "file" then
            if leaf then
                execute_action(leaf)
            end
            return
        end

        if node.expanded or not collapsed then
            if expanded then
                execute_action(expanded)
            end
            return
        end

        if collapsed then
            execute_action(collapsed)
        end
    end

end

---@param open string | fun() | nil
---@param close string | fun() | nil
---@return fun()
function M.smart_open(open, close)
    return function()
        if functions.is_open() then
            if open then
                open()
            end
            return
        end

        if close then
            close()
        end
    end
end

return M
