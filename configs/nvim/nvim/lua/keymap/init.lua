local KeymapResolver = require("keymap.resolver").KeymapResolver
local CallbackCondition = require("keymap.reactive.condition").CallbackCondition
local StatefulCondition = require("keymap.reactive.condition").StatefulCondition
local FixedCondition = require("keymap.reactive.condition").FixedCondition
local BufferSet = require("keymap.reactive.buffer_set").BufferSet
local KeymapState = require("keymap.state").KeymapState
local KeymapMediator = require("keymap.mediator").KeymapMediator

local M = {
    _mediator = KeymapMediator.new(KeymapResolver.new(), KeymapState.new()),

    StatefulCondition = StatefulCondition,
    CallbackCondition = CallbackCondition,
    FixedCondition = FixedCondition,
    BufferSet = BufferSet,
}

function M.setup()
    local autogroup = vim.api.nvim_create_augroup("d542d61bf91f.keymap", {})
    vim.api.nvim_create_autocmd("BufDelete", {
        group = autogroup,
        callback = function(args)
            local buffer = args.buf
            M._mediator:handle_buffer_deletion(buffer)
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

---@alias keymap.RegisterEntry {
---    action: keymap.Action,
---    when?: keymap.Condition,
---    buffers?: keymap.BufferSet,
---    options?: keymap.KeymapOptions,
---}

---@param mode keymap.Mode
---@param key keymap.Key
---@param entries keymap.RegisterEntry[]
function M.register(mode, key, entries)
    ---@type keymap.KeymapEntry[]
    local keymap_entries = vim.tbl_map(function(entry)
        return {
            action = entry.action,
            condition = entry.when or FixedCondition.new(true),
            buffers = entry.buffers or BufferSet.global(),
            options = entry.options or {},
        }
    end, entries)
    M._mediator:register(mode, key, keymap_entries)
end

function M.refresh()
    M._mediator:refresh()
end

return M
