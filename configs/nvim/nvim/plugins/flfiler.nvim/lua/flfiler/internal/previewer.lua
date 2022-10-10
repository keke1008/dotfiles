local utils = require("flfiler.utils")
local global = require("flfiler.global")

---@param path string
---@return "text" | "binary" | "directory"
local function file_type(path)
    local file, err = io.popen("file -b --mime-type " .. path, "r")
    if not file then
        error(err)
    end

    ---@type string
    local minetype = file:read("*a")
    if minetype:sub(1, 4) == "text" then
        return "text"
    end
    if minetype:sub(1, 5) == "inode" then
        return "directory"
    end
    return "binary"
end

---@param path string
---@param limit_byte number
local function is_file_size_small(path, limit_byte)
    local size_byte = vim.fn.getfsize(path)
    return size_byte ~= -2 and size_byte < limit_byte
end

---@param path string
---@return number
local function open_file_in_buffer(path)
    local bufname = "FlfilerPreview://" .. path

    -- When trying to open the same buffer consecutively
    if vim.fn.bufexists(bufname) == 1 then
        return vim.fn.bufnr(bufname)
    end

    local bufnr = utils.create_scratch_buffer()
    vim.api.nvim_buf_set_name(bufnr, bufname)

    local lines = vim.fn.readfile(path)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
    return bufnr
end

---@param winid number
---@param bufnr number
local function win_set_buf_noautocmd(winid, bufnr)
    local ei = vim.o.eventignore
    vim.o.eventignore = "all"
    pcall(vim.api.nvim_win_set_buf, winid, bufnr)
    vim.o.eventignore = ei

end

---@param winid number
---@param node EntryNode
local function show_file_in_window(winid, node)
    if node.type == "directory"
        or file_type(node.path) ~= "text"
        or not is_file_size_small(node.path, 1 * 1000 * 1000)
    then
        win_set_buf_noautocmd(winid, utils.create_scratch_buffer())
        return
    end

    vim.api.nvim_win_call(winid, function()
        local bufnr = open_file_in_buffer(node.path)
        win_set_buf_noautocmd(winid, bufnr)
        vim.cmd [[filetype detect]]
    end)
end

---@param winid number
---@param direction "up" | "down"
---@param half boolean
local function scroll(winid, direction, half)
    local key
    if direction == "up" then
        key = half and "<C-u>" or "<C-b>"
    else
        key = half and "<C-d>" or "<C-f>"
    end

    vim.api.nvim_win_call(winid, function()
        vim.cmd([[execute "normal! \]] .. key .. [["]])
    end)

end

---@param subscribe Subscribe<FlfilerMessage>
---@param filer AbstractFiler
local function attach_previewer(subscribe, filer)
    local winid = utils.open_window(global.get_config().layout.previewer())

    local unsubscribe = subscribe(function(event)
        if event.type == "cursor_moved" then
            show_file_in_window(winid, filer.cursor_node())
        elseif event.type == "close" then
            vim.api.nvim_win_close(winid, true)
            winid = nil
        elseif event.type == "scroll_preview" then
            scroll(winid, event.direction, event.half)
        end
    end)

    vim.api.nvim_create_autocmd("WinClosed", {
        once = true,
        pattern = tostring(winid),
        callback = unsubscribe
    })
end

return attach_previewer
