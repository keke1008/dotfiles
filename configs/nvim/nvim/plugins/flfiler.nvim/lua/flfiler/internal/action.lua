---@param command string
---@param filer AbstractFiler
---@param filer_winid number
---@param open_winid number
---@param remain_cursor boolean
local function open(command, filer, filer_winid, open_winid, remain_cursor)
    local filer_bufnr = vim.api.nvim_win_get_buf(filer_winid)
    local open_bufnr = vim.api.nvim_win_get_buf(open_winid)
    local bufhidden = vim.api.nvim_buf_get_option(open_bufnr, "bufhidden")
    vim.api.nvim_buf_set_option(open_bufnr, "bufhidden", "hide")

    vim.api.nvim_win_set_buf(open_winid, filer_bufnr)

    local filer_cursor = vim.api.nvim_win_get_cursor(filer_winid)
    vim.api.nvim_win_set_cursor(open_winid, filer_cursor)

    local new_winid = vim.api.nvim_win_call(open_winid, function()
        filer[command]()
        return vim.api.nvim_get_current_win()
    end)

    if new_winid ~= open_winid then
        vim.api.nvim_win_set_buf(open_winid, open_bufnr)
    end

    vim.api.nvim_buf_set_option(open_bufnr, "bufhidden", bufhidden)

    if remain_cursor then
        vim.api.nvim_set_current_win(filer_winid)
    else
        vim.api.nvim_set_current_win(new_winid)
        vim.api.nvim_win_call(filer_winid, filer.close)
    end
end

---@param filer AbstractFiler
---@param filer_winid number
---@param remain_cursor boolean
local function select(filer, filer_winid, remain_cursor)
    filer.select()

    if remain_cursor then
        vim.api.nvim_set_current_win(filer_winid)
    else
        vim.api.nvim_win_call(filer_winid, filer.close)
    end
end

---@param array string[]
---@param target string
---@return boolean
local function contains(array, target)
    for _, value in ipairs(array) do
        if value == target then
            return true
        end
    end
    return false
end

---@param subscribe Subscribe<FlfilerMessage>
---@param filer AbstractFiler
---@param filer_winid number
---@param caller_winid number
return function(subscribe, filer, filer_winid, caller_winid)
    subscribe(function(message, unsubscribe)
        if message.type == "close" then
            unsubscribe()
            return
        end
        if message.type ~= "filer_action" then
            return
        end

        local action = message.action

        if contains({ "edit", "split", "vsplit", "tabedit" }, message.action) then
            open(action, filer, filer_winid, caller_winid, message.remain_cursor)
        elseif action == "select" then
            select(filer, filer_winid, message.remain_cursor)
        elseif contains({ "expand", "collapse", "enter", "leave", "delete", "mark", "rename" }, message.action) then
            filer[action]()
        elseif action == "reveal" then
            filer.reveal(message.path)
        end
    end)
end
