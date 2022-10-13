local M = {}
---@return any
function M.call_fern_helper(property)
    local expr = string.format("fern#helper#call({ helper -> helper.%s() })", property)
    return vim.api.nvim_eval(expr)
end

---@alias FloatingFern.Node { type: "file", path: string } | { type: "directory", path: string, expanded: boolean }

---@return FloatingFern.Node
function M.get_cursor_node()
    local node = M.call_fern_helper("sync.get_cursor_node")
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

return M
