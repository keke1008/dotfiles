---@alias Caller { buffer: number, window: number }

---@class Fern
---@field caller Caller | nil
local Fern = {}

---@param caller_buffer number
---@param caller_window number
---@return Fern
function Fern.new(caller_buffer, caller_window)
    local self = {
        caller = {
            buffer = caller_buffer,
            window = caller_window,
        }
    }
    return setmetatable(self, { __index = Fern })
end

---@return Fern
function Fern.attach()
    local caller_buffer = vim.api.nvim_get_current_buf()
    local caller_window = vim.api.nvim_get_current_win()
    return Fern.new(caller_buffer, caller_window)
end

function Fern:assert_open()
    if not self.caller then
        error("Fern has already closed.")
    end
end

function Fern:close()
    self:assert_open()
    vim.api.nvim_set_current_buf(self.caller.buffer)
    self.caller = nil
end

---@return { [string]: any }
function Fern:helper()
    self:assert_open()
    return vim.fn['fern#helper#new']()
end

---@param f fun(fern: Fern)
function Fern.with_attach(f)
    local group = vim.api.nvim_create_augroup("fern-with-open", {})
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "fern",
        group = group,
        callback = function()
            f(Fern.attach())
        end
    })
end
