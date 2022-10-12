---@class Mapping
---@field fern Fern
local Mapping = {}

---@param fern Fern
---@return Mapping
function Mapping.new(fern)
    local self = {
        fern = fern
    }
    return setmetatable(self, { __index = Mapping })
end

---@param keys string
---@return fun()
function Mapping:with_close(keys)
    return function()
        keys = vim.api.nvim_replace_termcodes(keys, true, true, true) --[[@as string]]
        vim.api.nvim_feedkeys(keys, 'x', false)

        local current_window = vim.api.nvim_get_current_win()
        if current_window ~= self.fern.caller.window then
            self.fern:close()
        end
    end
end

全てのMappingを関数で提供する

return Mapping
