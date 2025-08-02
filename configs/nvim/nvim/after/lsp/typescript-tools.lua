local lsp = require("keke.utils.lsp")

lsp.on_attach("typescript-tools", function(bufnr, _)
    vim.keymap.set("n", "<leader>lD", "<CMD>TSToolsGoToSourceDefinition<CR>", { buffer = bufnr })
end)

return {
    root_dir = function(bufnr, on_dir)
        local deno_root = vim.fs.root(bufnr, lsp.DENO_ROOT_MARKER)
        if deno_root ~= nil then
            return
        end

        local marker = { "package.json", "tsconfig.json", "jsconfig.json", ".git" }
        return lsp.root_dir(marker)(bufnr, on_dir)
    end,
}
