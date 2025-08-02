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

return M
