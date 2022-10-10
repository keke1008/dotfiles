---@class FlfilerApi
---@field launch fun(path?: string)
---@field focus fun()
---@field focus_or_launch fun(path?: string)
---@field blur fun()
---@field close fun()
---@field edit fun(remain_cursor: boolean)
---@field split fun(remain_cursor: boolean)
---@field vsplit fun(remain_cursor: boolean)
---@field tabedit fun(remain_cursor: boolean)
---@field select fun(remain_cursor: boolean)
---@field expand fun()
---@field collapse fun()
---@field enter fun()
---@field leave fun()
---@field delete fun()
---@field mark fun()
---@field rename fun()
---@field cursor_node fun(): EntryNode
---@field reveal fun(path: string)

---@param flfiler fun(): Flfiler
---@param filer_api fun(): AbstractFilerApi
---@return FlfilerApi
return function(flfiler, filer_api)
    local api = {}

    ---@param path? string
    function api.launch(path)
        if not path then
            path = vim.fn.getcwd()
        end
        filer_api().edit()
        flfiler():open(path)
    end

    function api.focus()
        flfiler():focus()
    end

    ---@param path? string
    function api.focus_or_launch(path)
        if flfiler():is_open() then
            api.focus()
        else
            api.launch(path)
        end
    end

    function api.blur()
        if flfiler():is_open() then
            local bufnr = vim.fn.bufnr("#")
            local winid = vim.fn.win_findbuf(bufnr)[1]
            if winid then
                vim.api.nvim_set_current_win(winid)
            end
        end
    end

    function api.close()
        flfiler():close()
    end

    ---@param remain_cursor boolean
    local function move_focus(remain_cursor)
        if remain_cursor then
            flfiler():focus()
        else
            flfiler():close()
        end
    end

    ---@param command string
    ---@return fun(remain_cursor: boolean)
    local function edit(command)
        return function(remain_cursor)
            if not flfiler():is_open() then
                filer_api()[command]()
                return
            end

            local node = filer_api():cursor_node()
            if node.type == "directory" then
                return
            end

            local winid = flfiler():get_caller_winid()
            vim.api.nvim_set_current_win(winid)
            vim.cmd(command .. " " .. node.path)

            move_focus(remain_cursor)
        end
    end

    api.edit = edit("edit")
    api.split = edit("split")
    api.vsplit = edit("vsplit")
    api.tabedit = edit("tabedit")

    ---@param remain_cursor boolean
    function api.select(remain_cursor)
        filer_api().select()
        if flfiler():is_open() then
            move_focus(remain_cursor)
        end
    end

    local same_api_list = {
        "expand",
        "collapse",
        "enter",
        "leave",
        "delete",
        "mark",
        "rename",
        "cursor_node",
        "reveal",
    }
    for _, name in ipairs(same_api_list) do
        api[name] = function(...)
            filer_api()[name](...)
        end
    end

    return api
end
