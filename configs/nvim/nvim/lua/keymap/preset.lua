local BufferSet = require("keymap.reactive.buffer_set").BufferSet

local buffers = {}

---@private
---@type table<string, keymap.BufferSet>
buffers._filetype = {}

---@param filetype string
---@return keymap.BufferSet
function buffers.filetype(filetype)
    if buffers._filetype[filetype] == nil then
        buffers._filetype[filetype] = BufferSet:new()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = filetype,
            callback = function(args)
                buffers._filetype[filetype]:add(args.buf)
            end,
        })
    end

    return buffers._filetype[filetype]
end

return {
    buffers = buffers,
}
