local KeymapResolver = require("keymap.resolver").KeymapResolver
local CallbackCondition = require("keymap.reactive.condition").CallbackCondition
local StatefulCondition = require("keymap.reactive.condition").StatefulCondition
local BufferGroup = require("keymap.reactive.buffer_group").BufferGroup
local KeymapState = require("keymap.state").KeymapState
local KeymapMediator = require("keymap.mediator").KeymapMediator

local M = {
    _mediator = KeymapMediator.new(KeymapResolver.new(), KeymapState.new()),
    _buffers = {}
}

function M.setup()
    local autogroup = vim.api.nvim_create_augroup("d542d61bf91f.keymap", {})
    vim.api.nvim_create_autocmd("BufDelete", {
        group = autogroup,
        callback = function(args)
            local buffer = args.buf
            for _, buffers in ipairs(M._buffers) do
                buffers:remove(buffer)
            end
        end
    })

    local subcommands = {
        refresh = M.refresh
    }

    vim.api.nvim_create_user_command(
        "Keymap",
        function(args)
            local subcommand = args.fargs[1]
            local handler = subcommands[subcommand]
            if handler then
                handler()
            else
                vim.notify("Unknown keymap subcommand: " .. subcommand, vim.log.levels.ERROR)
            end
        end, {
            desc = "Refresh keymaps",
            nargs = '+',
            complete = function()
                return vim.tbl_keys(subcommands)
            end
        })
end

---@param mode keymap.Mode
---@param key keymap.Key
---@param entries keymap.KeymapEntry[]
function M.register(mode, key, entries)
    M._mediator:register(mode, key, entries)
end

---@param predicate fun(): boolean
---@return keymap.CallbackCondition
function M.new_callback_condition(predicate)
    local condition = CallbackCondition.new(predicate)
    M._mediator:register_signal(condition)
    return condition
end

---@param initial boolean?
---@return keymap.StatefulCondition
function M.new_stateful_condition(initial)
    local condition = StatefulCondition.new(initial)
    M._mediator:register_signal(condition)
    return condition
end

---@return keymap.BufferGroup
function M.new_buffer_group()
    local buffers = BufferGroup.new()
    M._mediator:register_signal(buffers)
    table.insert(M._buffers, buffers)
    return buffers
end

---@return keymap.BufferGroup
function M.new_global_buffer_group()
    local buffers = BufferGroup.global()
    M._mediator:register_signal(buffers)
    table.insert(M._buffers, buffers)
    return buffers
end

function M.refresh()
    M._mediator:refresh()
end

return M
