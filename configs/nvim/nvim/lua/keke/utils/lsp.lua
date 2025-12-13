local M = {}

---@param server_name string
---@param callback fun(bufnr: integer, client: table)
function M.on_attach(server_name, callback)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == server_name then
                callback(args.buf, client)
            end
        end,
    })
end

M.DENO_ROOT_MARKER = { "deno.json", "deno.jsonc" }

---@param marker string | string[] | fun(name: string, path: string): boolean
---@return fun(bufnr: integer, on_dir: fun(dir: string))
function M.root_dir(marker)
    return function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, marker)
        if root ~= nil then
            on_dir(root)
        end
    end
end

---@param marker string | string[] | fun(name: string, path: string): boolean
---@return fun(bufnr: integer, on_dir: fun(dir: string))
function M.root_dir_recursive(marker)
    return function(bufnr, on_dir)
        local path = vim.api.nvim_buf_get_name(bufnr)
        local dir = vim.fs.dirname(path)

        local find_dirs = vim.fs.find(marker, { path = dir, upward = true, limit = 10 })
        local root_dir = find_dirs[#find_dirs]
        if root_dir ~= nil then
            on_dir(vim.fs.dirname(root_dir))
        end
    end
end

---@param root_dir_fns fun(bufnr: integer, on_dir: fun(dir: string))[]
---@return fun(bufnr: integer, on_dir: fun(dir: string))
function M.any_root_dir(root_dir_fns)
    return function(bufnr, on_dir)
        local done = false
        for _, fn in ipairs(root_dir_fns) do
            fn(bufnr, function(dir)
                done = true
                on_dir(dir)
            end)

            if done then
                break
            end
        end
    end
end

return M
