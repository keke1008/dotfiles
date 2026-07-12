if vim.fn.executable("fzf") == 0 then
    return
end

---@class DeferredStack
---@field private stack fun()[]
local DeferredStack = {}

function DeferredStack.new()
    local self = {
        stack = {},
    }
    return setmetatable(self, { __index = DeferredStack })
end

---@param self DeferredStack
---@param f fun()
function DeferredStack:push(f)
    table.insert(self.stack, f)
end

function DeferredStack:run()
    while #self.stack > 0 do
        table.remove(self.stack)()
    end
end

---@class OpenFzfCreateWindowResult
---@field bufnr integer
---@field winid integer
---@field width integer

---@param deferred DeferredStack
---@param opts { on_close: fun() }
---@return OpenFzfCreateWindowResult?
local function create_window(deferred, opts)
    local bufnr = vim.api.nvim_create_buf(false, true)
    if bufnr == 0 then
        vim.notify("ERR: failed to create buffer", vim.log.levels.ERROR)
        return
    end
    deferred:push(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true, unload = false })
        end
    end)

    local win_opts = {
        relative = "editor",
        border = "none",
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.9),
        col = math.floor(vim.o.columns * 0.05),
        row = math.floor(vim.o.lines * 0.05),
    }
    local winid = vim.api.nvim_open_win(bufnr, true, win_opts)
    if winid == 0 then
        vim.notify("ERR: failed to create buffer", vim.log.levels.ERROR)
        return
    end
    deferred:push(function()
        if vim.api.nvim_win_is_valid(winid) then
            vim.api.nvim_win_close(winid, true)
        end
    end)

    vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(winid),
        callback = function()
            opts.on_close()
        end,
    })

    return {
        bufnr = bufnr,
        winid = winid,
        width = win_opts.width,
    }
end

---@class OpenFzfStartJobOpts
---@field result_path string
---@field fzf_cmd string
---@field on_selected fun(selections: string[])
---@field on_canceled fun()

---@param deferred DeferredStack
---@param opts OpenFzfStartJobOpts
---@return { cleanup: fun() }?
local function start_job(deferred, opts)
    local function handle_selection()
        local result_file, err_open = io.open(opts.result_path, "rb")
        if result_file == nil then
            local msg = string.format("ERR: could not open result file: %s", err_open)
            vim.notify(msg, vim.log.levels.ERROR)
            opts.on_canceled()
            return
        end

        local selections = {}
        for line in result_file:lines("*l") do
            table.insert(selections, line)
        end
        result_file:close()

        if #selections == 0 then
            opts.on_canceled()
        else
            opts.on_selected(selections)
        end
    end

    local jobid = vim.fn.jobstart(opts.fzf_cmd, {
        term = true,
        on_exit = handle_selection,
    })
    if jobid <= 0 then
        vim.notify("ERR: failed to spawn fzf process", vim.log.levels.ERROR)
        return
    end
    deferred:push(function()
        vim.fn.jobstop(jobid)
    end)

    return {
        jobid = jobid,
    }
end

---@class BuildFzfCmdOpts
---@field common_args string
---@field output_path string
---@field show_preview boolean

---@class OpenFzfOpts
---@field build_fzf_cmd fun(opts: BuildFzfCmdOpts): string
---@field on_selected fun(selections: string[])
---@field on_canceled fun()
---@field on_aborted fun()

---@param deferred DeferredStack
---@param opts OpenFzfOpts
local function open_fzf(deferred, opts)
    local window = create_window(deferred, {
        on_close = function()
            deferred:run()
        end,
    })
    if window == nil then
        deferred:run()
        opts.on_aborted()
        return
    end

    local output_path = vim.fn.tempname()
    deferred:push(function()
        vim.uv.fs_unlink(output_path)
    end)

    ---@type BuildFzfCmdOpts
    local build_fzf_opts = {
        common_args = table.concat({
            "--ansi",
            "--style=full",
            "--bind='ctrl-b:preview-half-page-up'",
            "--bind='ctrl-f:preview-half-page-down'",
        }, " "),
        output_path = output_path,
        show_preview = window.width >= 120,
    }

    local ok, fzf_cmd = pcall(opts.build_fzf_cmd, build_fzf_opts)
    if not ok then
        vim.notify("ERR: failed to build fzf_command: " .. fzf_cmd)
        deferred:run()
        opts.on_aborted()
        return
    end

    local job = start_job(deferred, {
        fzf_cmd = fzf_cmd,
        result_path = output_path,
        on_selected = function(selections)
            deferred:run()
            opts.on_selected(selections)
        end,
        on_canceled = function()
            deferred:run()
            opts.on_canceled()
        end,
    })
    if job == nil then
        deferred:run()
        opts.on_aborted()
        return
    end

    vim.cmd.startinsert()
    return true
end

vim.keymap.set("n", "<leader>ff", function()
    open_fzf(DeferredStack.new(), {
        build_fzf_cmd = function(opts)
            local preview_cmd
            if vim.fn.executable("bat") == 1 then
                preview_cmd = table.concat({
                    "bat",
                    "--style=numbers",
                    "--color=always",
                    "'{1}'",
                }, " ")
            else
                preview_cmd = "cat -n '{1}'"
            end

            local fzf_cmd = table.concat({
                "fzf",
                ("--preview='%s'"):format(preview_cmd),
                opts.common_args,
            }, " ")

            return ("%s > %s"):format(fzf_cmd, opts.output_path)
        end,
        on_selected = function(selections)
            vim.cmd.edit(selections[1])
        end,

        on_canceled = function() end,
        on_aborted = function() end,
    })
end, {})

vim.keymap.set("n", "<leader>fl", function()
    open_fzf(DeferredStack.new(), {
        build_fzf_cmd = function(opts)
            local preview_cmd, fzf_preview_args
            if not opts.show_preview then
                preview_cmd = ""
                fzf_preview_args = ""
            elseif vim.fn.executable("bat") == 1 then
                preview_cmd = table.concat({
                    "[ -n {1} ] &&",
                    "bat",
                    "--style=numbers",
                    "--color=always",
                    "--highlight-line={2}",
                    "{1}",
                }, " ")
                fzf_preview_args = ""
            else
                preview_cmd = "[ -n {1} ] && cat -n {1}"
                fzf_preview_args = "--preview-window=+{2}/2"
            end

            local ripgrep_cmd = table.concat({
                "rg",
                "--column",
                "--line-number",
                "--no-heading",
                "--color=always",
                "{q}",
            }, " ")

            local fzf_cmd = table.concat({
                "fzf",
                "--disabled",
                ("--bind='change:reload:%s'"):format(ripgrep_cmd),
                "--delimiter=':'",
                ("--preview='%s'"):format(preview_cmd),
                fzf_preview_args,
                opts.common_args,
            }, " ")

            return ("echo | %s > %s"):format(fzf_cmd, opts.output_path)
        end,
        on_selected = function(selections)
            local selection = selections[1]
            local file, row, col = selection:match("(.+):(%d+):(%d):.+$")

            if file ~= nil and row ~= nil and col ~= nil then
                vim.cmd.edit(file)
                vim.api.nvim_win_set_cursor(0, { tonumber(row), tonumber(col) - 1 })
            end
        end,
        on_canceled = function() end,
        on_aborted = function() end,
    })
end)

---@diagnostic disable: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
    opts = opts or {}
    on_choice = on_choice or function() end

    local inputs = vim.tbl_map(function(item)
        local escaped = tostring(item):gsub("\n", "\\n")
        return escaped
    end, items)
    local input_file_path = vim.fn.tempname()
    vim.fn.writefile(inputs, input_file_path)

    local deferred = DeferredStack.new()
    deferred:push(function()
        vim.uv.fs_unlink(input_file_path)
    end)

    open_fzf(deferred, {
        build_fzf_cmd = function(build_fzf_opts)
            local fzf_cmd = table.concat({
                ("--prompt='%s'"):format(opts.prompt or "Select one of: "),
                "--accept-nth='{n}",
                build_fzf_opts.common_args,
            }, " ")
            return ("cat '%s' | %s >%s"):format(input_file_path, fzf_cmd, build_fzf_opts.output_path)
        end,
        on_selected = function(selections)
            local fzf_index = tonumber(selections[1])
            if fzf_index ~= nil then
                local index = fzf_index + 1
                on_choice(inputs[index], index)
                return
            end

            on_choice()
        end,
        on_canceled = on_choice,
        on_aborted = on_choice,
    })
end
