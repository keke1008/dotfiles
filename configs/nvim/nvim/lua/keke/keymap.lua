local keymap = require("keymap")

keymap.setup()

local condition = keymap.StatefulCondition.new(true)
vim.uv.new_timer():start(1000, 1000, vim.schedule_wrap(function()
    condition:update(not condition:enabled())
end))

local buffers = keymap.BufferGroup.new()
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function(args)
        vim.print(args)
        buffers:add(args.buf)
    end,
})

keymap.register("n", "x", {
    {
        when = condition,
        buffers = buffers,
        action = "ix<Esc>",
        options = { silent = true },
    },
})
