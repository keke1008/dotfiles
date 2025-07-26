local KeymapResolver = require("keymap.resolver").KeymapResolver
local CallbackCondition = require("keymap.reactive.condition").CallbackCondition
local StatefulCondition = require("keymap.reactive.condition").StatefulCondition
local FixedCondition = require("keymap.reactive.condition").FixedCondition
local BufferSet = require("keymap.reactive.buffer_set").BufferSet
local KeymapState = require("keymap.state").KeymapState
local KeymapMediator = require("keymap.mediator").KeymapMediator
local validate = require("keymap.validate")
local types = require("keymap.types")

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
        end,
    })

    local subcommands = {
        refresh = M.refresh,
    }

    vim.api.nvim_create_user_command("Keymap", function(args)
        local subcommand = args.fargs[1]
        local handler = subcommands[subcommand]
        if handler then
            handler()
        else
            vim.notify("Unknown keymap subcommand: " .. subcommand, vim.log.levels.ERROR)
        end
    end, {
        desc = "Refresh keymaps",
        nargs = "+",
        complete = function()
            return vim.tbl_keys(subcommands)
        end,
    })
end

---@class keymap.KeymapContext
---@field mode? keymap.Mode | keymap.Mode[]
---@field key? keymap.Key | keymap.Key[]
---@field action? keymap.Action
---@field when? keymap.Condition
---@field buffers? keymap.BufferSet
---@field options? keymap.KeymapOptions
---@field module? keymap.Module[]

---@class keymap.KeymapSpec: keymap.KeymapOptions
---@field mode? keymap.Mode | keymap.Mode[]
---@field key? keymap.Key | keymap.Key[]
---@field action? keymap.Action
---@field when? keymap.Condition
---@field buffers? keymap.BufferSet
---@field module? keymap.Module | keymap.Module[]
---@field [integer] keymap.KeymapSpec

---@param spec keymap.KeymapSpec
function M.add(spec)
    M._mediator:with_batch_signal_handling(function()
        M._add_internal({}, spec)
    end)
end

---@private
---@param ctx keymap.KeymapContext
---@param spec keymap.KeymapSpec
function M._add_internal(ctx, spec)
    vim.validate("spec", spec, { "table" })

    local is_ctx = spec[1] ~= nil
    if is_ctx then
        local c = vim.deepcopy(ctx)
        for k, v in pairs(spec) do
            if type(k) == "string" then
                c[k] = v
            end
        end

        for k, v in pairs(spec) do
            if type(k) == "number" then
                M._add_internal(c, v)
            end
        end

        return
    end

    local modes = validate.modes(spec.mode or ctx.mode)
    local keys = validate.keys(spec.key or ctx.key)
    local action = validate.action(spec.action or ctx.action)
    local when = validate.condition(spec.when or ctx.when or FixedCondition.new(true))
    local buffers = validate.buffer_set(spec.buffers or ctx.buffers or BufferSet.global())
    local options = vim.tbl_extend("keep", validate.options(spec), ctx.options or {})

    for _, mode in ipairs(modes) do
        for _, key in ipairs(keys) do
            M._mediator:add_keymap({
                mode = mode,
                key = key,
                action = action,
                condition = when,
                buffers = buffers,
                options = options,
            })
        end
    end
end

function M.refresh()
    M._mediator:refresh()
end

return M
